const cds = require("@sap/cds");
let workflowApi = require("./workflowApi");
class service extends cds.ApplicationService {
  async init() {
    const {
      Invoices,
      InvoiceItems,
      InvoiceWorkflows,
      Suppliers,
      CompanyCodes,
    } = this.entities;
    const db = await cds.connect.to("db");
    // Check whether supplier is blocked or valid supplier
    this.before("CREATE", Invoices, async (req) => {
      const supplierdata = await cds
        .read(Suppliers)
        .byKey(req.data.supplier_ID);
      if (supplierdata.IsBlocked) {
        console.log("Supplier is blocked");
        req.reject(
          400,
          "Supplier is blocked, please choose a different supplier"
        );
      }
    });

    // Invoice with status posted should not be deleted.
    this.before("DELETE", Invoices, async (req) => {
      let dbHdrInfo = await cds.read(Invoices).where({ ID: req.params[0].ID });

      if (dbHdrInfo["status"] === "Post") {
        req.reject(400, "Invoice with posted status cannot be deleted");
      }
    });

    // Auto-increment Invoice ID when user clicks on create on the Invoice table
    this.before("NEW", Invoices, async (req) => {
      let { maxID } = await SELECT.one`max(invoiceID) as maxID`.from(Invoices);
      if (!maxID) {
        maxID = "50000000";
      }
      req.data.invoiceID = (parseInt(maxID) + 1).toString();
    });

    this.before("NEW", InvoiceItems, async (req) => {
      let result = await cds
        .read(InvoiceItems.drafts)
        .columns(["invoice_ID"])
        .where({ invoice_ID: req.data.invoice_ID });
      req.data.invItem = (parseInt(result.length) + 1).toString();

      let hdrDraft = await cds
        .read(Invoices.drafts)
        .columns(["currency_code"])
        .where({ ID: req.data.invoice_ID });
      req.data.currency_code = hdrDraft[0].currency_code;
    });

    this.on("getOrderDefaults", async (req) => {
      return { status: "Park" };
    });

    this.on("setOrderProcessing", Invoices, async (req) => {
      //await cds.update(Invoices, req.params[0].ID).set({ status: "Post" });

      let dbHdrInfo = await cds.read(Invoices).where({ ID: req.params[0].ID });
      let dbHdr = dbHdrInfo[0];
      const context = {
        Invoices: {
          ID: dbHdr.ID,
        },
      };
      const definitionId = "demo_leadingworkflow";
      const response = await workflowApi.StartInstance(context, definitionId);

      const wfitem = await this.create(InvoiceWorkflows).entries({
        invoice_ID: req.params[0].ID,
        wfstatus: "WF Initiated",
        instanceID: response.id,
      });

      await cds.update(Invoices, req.params[0].ID).set({
        wfstatus: "WF Initiated",
        instanceID: response.id,
      });

      req.notify(`Workflow Task processed for Reqinfo`);

      if (
        dbHdrInfo[0].supplier_ID !== undefined &&
        dbHdrInfo[0].supplier_ID !== null
      ) {
        console.log(
          `Event was emitted for Suplier "${dbHdrInfo[0].supplier_ID}" with amt "${dbHdrInfo[0].totamount}"`
        );
        await this.emit("amountAssigned", {
          supplier_ID: dbHdrInfo[0].supplier_ID,
          amountopen: dbHdrInfo[0].totamount * -1,
          amountclose: dbHdrInfo[0].totamount,
        });
      }
    });

    this.on("setOrderOpen", Invoices, async (req) => {
      await cds
        .update(Invoices, req.params[0].ID)
        .set({ status: "Park", wfstatus: "" });

      let dbHdrInfo = await cds.read(Invoices).where({ ID: req.params[0].ID });
      if (
        dbHdrInfo[0].supplier_ID !== undefined &&
        dbHdrInfo[0].supplier_ID !== null
      ) {
        console.log(
          `Event was emitted for Suplier "${dbHdrInfo[0].supplier_ID}" with amt "${dbHdrInfo[0].totamount}"`
        );
        await this.emit("amountAssigned", {
          supplier_ID: dbHdrInfo[0].supplier_ID,
          amountopen: dbHdrInfo[0].totamount,
          amountclose: dbHdrInfo[0].totamount * -1,
        });
      }
    });

    this.on("requestInfo", Invoices, async (req) => {
      //const emailToValidate = req.data.SendTo;
      const emailToValidate = req.data.SendTo.split(/[,]/);
      const emailRegexp =
        /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;

      if (emailRegexp.test(emailToValidate[0]) === false) {
        req.reject(400, "ASSERT_FORMAT", [emailToValidate[0], "@sap.com"]);
        return;
      }

      let dbHdrInfo = await cds.read(Invoices).where({ ID: req.params[0].ID });
      let dbHdr = dbHdrInfo[0];
      const context = {
        Recipients: emailToValidate,
        IsMultipleApprovars: req.data.IsMultipleApprovars,
        Invoices: {
          ID: dbHdr.ID,
        },
      };
      const definitionId = "requestforinformation";
      const response = await workflowApi.StartInstance(context, definitionId);

      // emailToValidate.forEach(async (element) => {
      const wfitem = await this.create(InvoiceWorkflows).entries({
        invoice_ID: req.params[0].ID,
        wfstatus: "WF Initiated",
        wfapprover: req.data.SendTo,
        requestcomment: req.data.Description,
        instanceID: response.id,
      });
      // })

      await cds.update(Invoices, req.params[0].ID).set({
        wfstatus: "WF Initiated",
        wfapprover: req.data.SendTo,
        requestcomment: req.data.Description,
        instanceID: response.id,
      });

      req.notify(`Workflow Task processed for Reqinfo`);
    });

    this.on("updateWFInfo", Invoices, async (req) => {
      if (req.data.isFinalStep) {
        await cds.update(Invoices, req.params[0].ID).set({
          wfstatus: req.data.wfstatus,
        });
      } else {
        let wfStatus = "";
        if (req.data.IsMultipleApprovars) {
          wfStatus = "In Approval";
        } else {
          wfStatus = req.data.wfstatus;
        }

        await cds.update(Invoices, req.params[0].ID).set({
          status: req.data.status,
          wfstatus: wfStatus, //req.data.wfstatus,
          responsecomment: req.data.responsecomment,
          wfapprover: req.data.wfapprover,
          instanceID: req.data.instanceID,
        });

        let dbWFInfo = await cds
          .read(InvoiceWorkflows)
          .where({ instanceID: req.data.instanceID });
        if (dbWFInfo.length !== 0) {
          await cds.update(InvoiceWorkflows, dbWFInfo[0].ID).set({
            wfstatus: req.data.wfstatus,
            responsecomment: req.data.responsecomment,
            wfapprover: req.data.wfapprover,
            //instanceID: req.data.instanceID,
          });
        } else {
          const wfitem = await this.create(InvoiceWorkflows).entries({
            invoice_ID: req.params[0].ID,
            wfstatus: req.data.wfstatus,
            wfapprover: req.data.wfapprover,
            responsecomment: req.data.responsecomment,
            requestcomment: req.data.requestcomment,
            instanceID: req.data.instanceID,
          });
        }
      }
    });

    this.before("PATCH", Invoices, async (req) => {
      if (req.data.postingDate) {
        req.data.fiscalyear = new Date(req.data.postingDate)
          .getFullYear()
          .toString();
      }

      if (req.data.companycode_companycode) {
        let dbComInfo = await cds
          .read(CompanyCodes)
          .where({ companycode: req.data.companycode_companycode });
        req.data.currency_code = dbComInfo[0].currency_code;
      }
    });

    this.after("PATCH", InvoiceItems, async (data) => {
      if (data.quantity || data.price) {
        let dbItemInfos2 = await cds
          .read(InvoiceItems.drafts)
          .where({ ID: data.ID });
        if (dbItemInfos2[0].quantity) {
          data.netprice = dbItemInfos2[0].price / dbItemInfos2[0].quantity;
        } else {
          data.netprice = dbItemInfos2[0].price;
        }
        await cds
          .update(InvoiceItems.drafts, data.ID)
          .set({ netprice: data.netprice });
      }

      let orderInfo = { totamount: 0 };

      let result = await cds
        .read(InvoiceItems.drafts)
        .where({ ID: data.ID })
        .columns(["invoice_ID"]);

      let dbItemInfos = await cds
        .read(InvoiceItems.drafts)
        .where({ invoice_ID: result[0].invoice_ID });

      orderInfo.totamount = dbItemInfos.reduce(
        (accumulator, currentValue) => accumulator + Number(currentValue.price),
        0
      );
      orderInfo.currency_code = dbItemInfos[0].currency_code;

      await cds.update(Invoices.drafts, result[0].invoice_ID).set(orderInfo);
      let dbHdrInfo = await cds
        .read(Invoices.drafts)
        .where({ ID: result[0].invoice_ID });
      if (
        dbHdrInfo[0].supplier_ID !== undefined &&
        dbHdrInfo[0].supplier_ID !== null
      ) {
        console.log(
          `Event was emitted for Suplier "${dbHdrInfo[0].supplier_ID}" with amt "${dbHdrInfo[0].totamount}"`
        );
        await this.emit("amountAssigned", {
          supplier_ID: dbHdrInfo[0].supplier_ID,
          amountopen:
            dbHdrInfo[0].status === "Park" ? dbHdrInfo[0].totamount : 0,
          amountclose:
            dbHdrInfo[0].status === "Post" ? dbHdrInfo[0].totamount : 0,
        });
      }
    });

    await super.init();
  }
}
module.exports = service;

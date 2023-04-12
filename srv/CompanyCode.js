module.exports = cds.service.impl(async function () {
  const invoiceservice = await cds.connect.to("invoicesrv");
  const { Suppliers } = this.entities;

  invoiceservice.on("amountAssigned", async (msg) => {
    const orderInfo = { amountopen: 0, amountclose: 0 };
    const supplier_ID = msg.data.supplier_ID;
    const { Suppliers } = this.entities;
    orderInfo.amountopen = msg.data.amountopen;
    orderInfo.amountclose = msg.data.amountclose;

    let SuppInfo = await cds.read(Suppliers).byKey(supplier_ID);
    await cds.update(Suppliers, supplier_ID).set({
      amountopen: Number(orderInfo.amountopen) + Number(SuppInfo.amountopen),
      amountclose: Number(orderInfo.amountclose) + Number(SuppInfo.amountclose),
    });
    console.log(
      "==> Received msg of type myEventName:" +
        msg.data.supplier_ID +
        "Amt" +
        msg.data.amountopen
    );
  });

  this.before("NEW", Suppliers, async (req) => {
    let { maxID } = await SELECT.one`max(supplier) as maxID`.from(Suppliers);
    if (!maxID) {
      maxID = "100000";
    }
    req.data.supplier = (parseInt(maxID) + 1).toString();
  });
});

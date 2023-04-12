namespace invoice.db;

using {
    managed,
    cuid,
    Currency
} from '@sap/cds/common';

using companycode.db as db from './CompanyCode';

entity GLAccount {
    key id   : String(50);
        name : String(200);
}

entity CostCenetr {
    key id                : String(50);
        name              : String(200);
        PersonResponsible : String(50);
}

entity PurchaseOrder {
    key purchaseorder : String(10);
        reference     : String(50);
        creator       : String(50);
}

entity Invoices : cuid, managed {
    invoiceID       : String(10);
    fiscalyear      : String(4);
    postingDate     : Date;
    documentDate    : Date;
    companycode     : Association to one db.CompanyCodes;
    supplier        : Association to one db.Suppliers;
    reference       : String(100);
    status          : String(20);
    totamount       : Decimal;
    currency        : Currency;
    instanceID      : UUID;
    wfstatus        : String(50);
    wfapprover      : String(225);
    requestcomment  : String(225);
    responsecomment : String(225);
    address         : String(225);
    items           : Composition of many InvoiceItems
                          on items.invoice = $self;
    wfitems         : Composition of many InvoiceWorkflows
                          on wfitems.invoice = $self;

}

entity InvoiceItems : cuid, managed {
    invItem       : String(10);
    invoice       : Association to Invoices;
    purchaseorder : Association to one PurchaseOrder;
    poitem        : String(5);
    glaccount     : Association to one GLAccount;
    costCenter    : Association to one CostCenetr;
    quantity      : Integer;
    price         : Decimal;
    netprice      : Decimal;
    currency      : Currency;
}

entity InvoiceWorkflows : cuid, managed {
    invoice         : Association to Invoices;
    instanceID      : UUID;
    wfstatus        : String(50);
    wfapprover      : String(225);
    requestcomment  : String(225);
    responsecomment : String(225);
}

entity WFUsers {
    key id    : String(10);
        name  : String(50);
        email : String(50);
}

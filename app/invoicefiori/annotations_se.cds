using invoicesrv as service from '../../srv/Invoice';

annotate service.Invoices @(Common: {SideEffects #CompanyCodeChanged: {
    SourceProperties: ['companycode_companycode'],
    TargetEntities  : [
        companycode,
        companycode.addresses
    ],
    TargetProperties: ['currency_code']
}});

annotate service.Invoices @(Common: {SideEffects #PostingDateChanged: {
    SourceProperties: ['postingDate'],
    TargetProperties: ['fiscalyear']
}});

annotate service.Invoices @(Common: {SideEffects #ItemChanged: {
    SourceEntities  : [items],
    TargetProperties: [
        'totamount',
        'currency_code'
    ]
}});

annotate service.InvoiceItems @(Common: {SideEffects #AmmountChanged: {
    SourceProperties: [
        'price',
        'quantity'
    ],
    TargetProperties: ['netprice']
}});

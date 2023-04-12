namespace companycode.db;

using {
    managed,
    cuid,
    Currency
} from '@sap/cds/common';

entity CompanyCodes : managed {
    key companycode : String(4) @assert.range: [
            1000,
            1999
        ];
        name        : String(100);
        currency    : Currency;
        addresses   : Composition of many Addresses
                          on addresses.companycode = $self;
        Suppliers   : Composition of many Suppliers
                          on Suppliers.companycode = $self

}

entity Suppliers : cuid, managed {
    supplier    : String(10);
    name        : String(50);
    amountopen  : Decimal;
    amountclose : Decimal;
    IsBlocked   : Boolean;
    companycode : Association to CompanyCodes;
    addresses   : Composition of many Addresses
                      on addresses.supplier = $self;
}

entity Addresses : cuid, managed {
    supplier    : Association to Suppliers;
    companycode : Association to CompanyCodes;
    country     : String(30);
    state       : String(30);
    city        : String(30);
    address     : String(100);
    zipcode     : String(10);
    default     : Boolean;
}

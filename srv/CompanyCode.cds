using companycode.db as db from '../db/CompanyCode';

service companycodesrv @(path: 'service/companycode') {
    entity CompanyCodes as projection on db.CompanyCodes;
    entity Suppliers    as projection on db.Suppliers;
    entity Addresses    as projection on db.Addresses;
}

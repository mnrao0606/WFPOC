using companycode.db as db from '../db/CompanyCode';
using invoice.db as invdb from '../db/Invoice';

service invoicesrv @(path: 'service/invoice') {
    entity CompanyCodes     as projection on db.CompanyCodes;
    entity Suppliers        as projection on db.Suppliers;
    entity Addresses        as projection on db.Addresses;
    entity GLAccount        as projection on invdb.GLAccount;
    entity CostCenetr       as projection on invdb.CostCenetr;
    entity PurchaseOrder    as projection on invdb.PurchaseOrder;
    entity InvoiceWorkflows as projection on invdb.InvoiceWorkflows;
    entity WFUsers          as projection on invdb.WFUsers;

    entity Invoices         as projection on invdb.Invoices actions {

        @(
            cds.odata.bindingparameter.name: '_it',
            Common.SideEffects             : {TargetProperties: ['_it/status']}
        )
        action setOrderProcessing();

        @(
            cds.odata.bindingparameter.name: '_it',
            Common.SideEffects             : {TargetProperties: [
                '_it/status',
                '_it/wfstatus',
            ]}
        )
        action setOrderOpen();

        @(
            cds.odata.bindingparameter.name: '_it',
            Common.SideEffects             : {
                TargetProperties: [
                    '_it/wfstatus',
                    '_it/wfapprover',
                    '_it/requestcomment',
                    '_it/instanceID',
                ],
                TargetEntities  : ['_it/wfitems'],
            }
        )
        action requestInfo(SendTo : String(500) @label              : 'Send To'
                                                @(
            Common.ValueList               : {
                $Type         : 'Common.ValueListType',
                CollectionPath: 'WFUsers',
                Parameters    : [
                    {
                        $Type            : 'Common.ValueListParameterDisplayOnly',
                        ValueListProperty: 'id',
                    },
                    {
                        $Type            : 'Common.ValueListParameterDisplayOnly',
                        ValueListProperty: 'name',
                    },
                    {
                        $Type            : 'Common.ValueListParameterInOut',
                        LocalDataProperty: SendTo,
                        ValueListProperty: 'email',
                    }
                ],
            },
            Common.ValueListWithFixedValues: false
        )
                                                @Common.FieldControl: #Mandatory,
        Description : String(100)               @label              : 'Description'                          @Common.FieldControl     : #Mandatory,
        IsMultipleApprovars : Boolean           @label              : 'I need answer from all participants'  @UI.ParameterDefaultValue: false  ) returns Invoices;

        action updateWFInfo(isFinalStep : Boolean, IsMultipleApprovars : Boolean, requestcomment : String(225), responsecomment : String(225), wfstatus : String(500), status : String(50), wfapprover : String(50), instanceID : UUID);

    };


    function getOrderDefaults() returns Invoices;

    event amountAssigned {
        supplier_ID : type of Suppliers : ID;
        amountopen  : type of Suppliers : amountopen;
        amountclose : type of Suppliers : amountclose;
    }

}

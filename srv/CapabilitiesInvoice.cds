using {invoicesrv as service} from './Invoice';
using from '@sap/cds/common';

annotate service.CompanyCodes with @(readonly: true);
annotate service.Suppliers with @(readonly: true);
annotate service.Addresses with @(readonly: true);
annotate service.GLAccount with @(readonly: true);
annotate service.CostCenetr with @(readonly: true);
annotate service.PurchaseOrder with @(readonly: true);
annotate service.InvoiceWorkflows with @(UI.UpdateHidden: true);
annotate service.WFUsers with @(readonly: true);
annotate service.Invoices with @(odata.draft.enabled: true);

annotate service.Invoices with @(UI.HeaderInfo: {
    TypeName      : 'Invoice',
    TypeNamePlural: 'Invoices',
    ImageUrl      : 'https://github.githubassets.com/images/modules/open_graph/github-octocat.png',
    Title         : {
        $Type: 'UI.DataField',
        Value: invoiceID,
    },
    Description   : {
        $Type: 'UI.DataField',
        Value: fiscalyear,
    },
});

annotate service.Invoices with {
    companycode  @title               : 'Company Code'  @Common.FieldControl: #Mandatory;
    supplier     @title               : 'Supplier'      @Common.FieldControl: #Mandatory;
    postingDate  @title               : 'Posting Date'  @Common.FieldControl: #Mandatory;
    companycode  @Common.Text         : {
        $value                : companycode.name,
        ![@UI.TextArrangement]: #TextLast,
    };
    supplier     @Common.Text         : {$value: supplier.name, };
    totamount    @Measures.ISOCurrency: currency_code;
    status       @title               : 'Status';
    invoiceID    @title               : 'Invoice';
};

annotate service.Invoices with @UI: {
    PresentationVariant: {
        SortOrder     : [{
            Property  : createdAt,
            Descending: true,
        }, ],
        Visualizations: ['@UI.LineItem'],
    },
    LineItem           : [
        {
            $Type: 'UI.DataField',
            Label: 'Company Code',
            Value: companycode.companycode,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Invoice',
            Value: invoiceID,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Fiscal Year',
            Value: fiscalyear,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Posting Date',
            Value: postingDate,
        },
        {
            $Type: 'UI.DataField',
            Value: supplier.name,
            Label: 'Supplier Name',
        },
        {
            $Type: 'UI.DataField',
            Value: status,
            Label: 'Status',
        },
        {
            $Type: 'UI.DataField',
            Label: 'Workflow Status',
            Value: wfstatus,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Total Amount',
            Value: totamount,
        },
    ]
};


annotate service.Invoices with @(

    UI.FieldGroup #GeneratedGroup1: {
        $Type: 'UI.FieldGroupType',
        Data : [],
    },
    UI.Facets                     : [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Genral Information',
            ID    : 'GeneralInformation',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Supplier Information',
                    ID    : 'SupplierInfo',
                    Target: '@UI.FieldGroup#SupplierInfo',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Invoice Info',
                    ID    : 'OrderInfo',
                    Target: '@UI.FieldGroup#OrderInfo',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Latest Workflow Info',
                    ID    : 'WorkflowInfo',
                    Target: '@UI.FieldGroup#WorkflowInfo',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Supplier Address',
                    ID    : 'Address',
                    Target: 'supplier/addresses/@UI.LineItem#Address',
                },
            ],
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Invoice Items',
            ID    : 'OrderItems',
            Target: 'items/@UI.LineItem#InvoiceItems',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Workflow Info',
            ID    : 'InvoiceWorkflows',
            Target: 'wfitems/@UI.LineItem#InvoiceWorkflows',
        },
    ]
);


annotate service.Invoices with @(UI.FieldGroup #OrderInfo: {
    $Type: 'UI.FieldGroupType',
    Data : [
        {
            $Type: 'UI.DataField',
            Label: 'Posting Date',
            Value: postingDate,
        },
        {
            $Type: 'UI.DataField',
            Value: documentDate,
            Label: 'Document Date',
        },
        {
            $Type: 'UI.DataField',
            Label: 'Reference',
            Value: reference,
        },
    ],
});

annotate service.Invoices with @(UI.FieldGroup #SupplierInfo: {
    $Type: 'UI.FieldGroupType',
    Data : [
        {
            $Type: 'UI.DataField',
            Label: 'Company Code',
            Value: companycode_companycode,
        },
        {
            $Type        : 'UI.DataField',
            Value        : supplier_ID,
            Label        : 'Supplier',
            ![@UI.Hidden]: {$edmJson: {$If: [
                {$Eq: [
                    {$Path: 'IsActiveEntity'},
                    true
                ]},
                true,
                false
            ]}}
        },
        {
            $Type        : 'UI.DataField',
            Value        : supplier.supplier,
            Label        : 'Supplier',
            ![@UI.Hidden]: {$edmJson: {$If: [
                {$Eq: [
                    {$Path: 'IsActiveEntity'},
                    false
                ]},
                true,
                false
            ]}}
        },
        {
            $Type: 'UI.DataField',
            Value: supplier.name,
            Label: 'Supplier Name',
        },
    ],
});

annotate service.Invoices with @(UI.FieldGroup #WorkflowInfo: {
    $Type: 'UI.FieldGroupType',
    Data : [
        {
            $Type                  : 'UI.DataField',
            Label                  : 'Workflow Status',
            Value                  : wfstatus,
            ![@Common.FieldControl]: #ReadOnly
        },
        {
            $Type                  : 'UI.DataField',
            Label                  : 'Workflow Approver',
            Value                  : wfapprover,
            ![@Common.FieldControl]: #ReadOnly
        },
        {
            $Type                  : 'UI.DataField',
            Label                  : 'Requester Comments',
            Value                  : requestcomment,
            ![@Common.FieldControl]: #ReadOnly
        },
        {
            $Type                  : 'UI.DataField',
            Value                  : responsecomment,
            Label                  : 'Agent Comments',
            ![@Common.FieldControl]: #ReadOnly
        },
        {
            $Type                  : 'UI.DataField',
            Label                  : 'Instance ID',
            Value                  : instanceID,
            ![@Common.FieldControl]: #ReadOnly
        },
    ],
});

annotate service.Invoices with {
    companycode @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'CompanyCodes',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: companycode_companycode,
                    ValueListProperty: 'companycode',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'currency_code',
                },
            ],
        },
        Common.ValueListWithFixedValues: false
    )
};

annotate service.Invoices with {
    supplier @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Suppliers',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: supplier_ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'supplier',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'companycode_companycode',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
            ],
        },
        Common.ValueListWithFixedValues: false
    )
};

annotate service.Invoices @(Common: {SideEffects #CCChanged: {
    SourceProperties: ['supplier_ID'],
    TargetProperties: ['address'],
    TargetEntities  : [
        supplier,
        supplier.addresses
    ]
},

});

annotate service.Invoices with @(UI.SelectionFields: [
    invoiceID,
    supplier_ID,
    companycode_companycode,
    postingDate,
    status,
]);

//annotate service.Invoices with @(Common.DefaultValuesFunction: 'getOrderDefaults');
annotate service.Addresses with @(Capabilities.SearchRestrictions.Searchable: false);
annotate service.InvoiceItems with @(Capabilities.SearchRestrictions.Searchable: false);
annotate service.InvoiceWorkflows with @(Capabilities.SearchRestrictions.Searchable: false);
annotate service.WFUsers with @(Capabilities.SearchRestrictions.Searchable: false);

annotate service.Addresses with @(UI.LineItem #Address: [
    {
        $Type: 'UI.DataField',
        Value: country,
        Label: 'Country',
    },
    {
        $Type: 'UI.DataField',
        Value: state,
        Label: 'State',
    },
    {
        $Type: 'UI.DataField',
        Value: city,
        Label: 'City',
    },
    {
        $Type: 'UI.DataField',
        Value: address,
        Label: 'Address',
    },
    {
        $Type: 'UI.DataField',
        Value: zipcode,
        Label: 'Zip Code',
    },
    {
        $Type: 'UI.DataField',
        Value: default,
        Label: 'Default',
    }
]);

annotate service.InvoiceItems with @(UI.LineItem #InvoiceItems: [
    {
        $Type                  : 'UI.DataField',
        Value                  : invItem,
        Label                  : 'Item',
        ![@Common.FieldControl]: #ReadOnly,
    },
    {
        $Type: 'UI.DataField',
        Value: purchaseorder_purchaseorder,
        Label: 'Purchase Order',
    },
    {
        $Type: 'UI.DataField',
        Value: poitem,
        Label: 'PO Item',
    },
    {
        $Type: 'UI.DataField',
        Value: glaccount_id,
        Label: 'GL Account',
    },
    {
        $Type: 'UI.DataField',
        Value: costCenter_id,
        Label: 'Cost Center',
    },
    {
        $Type: 'UI.DataField',
        Value: price,
        Label: 'Price',
    //  ![@Common.FieldControl] : #ReadOnly
    },
    {
        $Type: 'UI.DataField',
        Value: quantity,
        Label: 'Quantity',
    },
    {
        $Type                  : 'UI.DataField',
        Value                  : netprice,
        Label                  : 'Net Price',
        ![@Common.FieldControl]: #ReadOnly,
    },
]);

annotate service.InvoiceItems with @(UI.LineItem #Address: []);

annotate service.InvoiceItems with {
    currency @Common.Text         : currency.descr;
    price    @Measures.ISOCurrency: currency_code;
};

annotate service.InvoiceItems with {
    glaccount @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'GLAccount',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: glaccount_id,
                    ValueListProperty: 'id',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                }
            ],
        },
        Common.ValueListWithFixedValues: false
    )
};

annotate service.InvoiceItems with {
    costCenter @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'CostCenetr',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: costCenter_id,
                    ValueListProperty: 'id',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'PersonResponsible',
                }
            ],
        },
        Common.ValueListWithFixedValues: false
    )
};

annotate service.InvoiceItems with {
    purchaseorder @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'PurchaseOrder',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: purchaseorder_purchaseorder,
                    ValueListProperty: 'purchaseorder',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'reference',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'creator',
                }
            ],
        },
        Common.ValueListWithFixedValues: false
    )
};

annotate service.Invoices with @(
    UI.DataPoint #invoiceStatus : {
        $Type      : 'UI.DataPointType',
        Title      : 'Invoice Status',
        Value      : status,
        Criticality: {$edmJson: {$If: [
            {$Eq: [
                {$Path: 'status'},
                'Park'
            ]},
            1,
            3
        ]}},
    },
    UI.DataPoint #grossAmount   : {
        $Type      : 'UI.DataPointType',
        Title      : 'Total Amount',
        Value      : totamount,
        Criticality: #Neutral,
    },
    UI.DataPoint #workflowStatus: {
        $Type      : 'UI.DataPointType',
        Value      : wfstatus,
        Title      : 'Workflow Status',
        Criticality: {$edmJson: {$If: [
            {$Eq: [
                {$Path: 'wfstatus'},
                'Approved'
            ]},
            3,
            2
        ]}},
    }
);

annotate service.Invoices with @(UI.HeaderFacets: [
    {
        $Type : 'UI.ReferenceFacet',
        Target: '@UI.DataPoint#invoiceStatus',
    },
    {
        $Type : 'UI.ReferenceFacet',
        Target: '@UI.DataPoint#grossAmount',
    },
    {
        $Type : 'UI.ReferenceFacet',
        ID    : 'workflowStatus',
        Target: '@UI.DataPoint#workflowStatus',
    },
]);


annotate service.InvoiceWorkflows with @UI: {
    PresentationVariant       : {
        SortOrder     : [{
            Property  : createdAt,
            Descending: true,
        }, ],
        Visualizations: ['@UI.LineItem#InvoiceWorkflows'],
    },
    LineItem #InvoiceWorkflows: [
        {
            $Type                  : 'UI.DataField',
            Value                  : instanceID,
            Label                  : 'Instance ID',
            ![@Common.FieldControl]: #ReadOnly,
        },
        {
            $Type                  : 'UI.DataField',
            Value                  : wfstatus,
            Label                  : 'WF Status',
            ![@Common.FieldControl]: #ReadOnly,
        },
        {
            $Type                  : 'UI.DataField',
            Value                  : wfapprover,
            Label                  : 'WF Approver',
            ![@Common.FieldControl]: #ReadOnly,
        },
        {
            $Type                  : 'UI.DataField',
            Value                  : requestcomment,
            Label                  : 'Request Comment',
            ![@Common.FieldControl]: #ReadOnly,
        },
        {
            $Type                  : 'UI.DataField',
            Value                  : responsecomment,
            Label                  : 'Response Comment',
            ![@Common.FieldControl]: #ReadOnly,
        },
    ]
};

annotate service.WFUsers with {
    id    @title: 'User ID';
    name  @title: 'User Name';
    email @title: 'User Email';
};

using {companycodesrv as service} from './CompanyCode';

annotate service.CompanyCodes with @(odata.draft.enabled: true);

annotate service.CompanyCodes with @(UI.HeaderInfo: {
    TypeName      : 'Company Code',
    TypeNamePlural: 'Company Codes',
    Title         : {
        $Type: 'UI.DataField',
        Value: name,
    },
});

annotate service.CompanyCodes with {
    name         @title              : 'Company Name'  @Common.FieldControl: #Mandatory;
    currency     @Common.FieldControl: #Mandatory;
    companycode  @title              : 'Company Code'  @Common.Text        : {
        $value                : name,
        ![@UI.TextArrangement]: #TextLast,
    }
};

annotate service.CompanyCodes with @(UI.LineItem: [
    {
        $Type: 'UI.DataField',
        Label: 'Company Code',
        Value: companycode,
    },
    {
        $Type: 'UI.DataField',
        Label: 'Company Name',
        Value: name,
    },
    {
        $Type: 'UI.DataField',
        Value: currency_code,
    },
]);

annotate service.CompanyCodes with @(
    UI.FieldGroup #GeneratedGroup1: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Company Code',
                Value: companycode,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Company Name',
                Value: name,
            },
            {
                $Type: 'UI.DataField',
                Value: currency_code,
            },
        ],
    },
    UI.Facets                     : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet1',
            Label : 'General Information',
            Target: '@UI.FieldGroup#GeneratedGroup1',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Addresses',
            ID    : 'Addresses',
            Target: 'addresses/@UI.LineItem#Addresses',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Suppliers',
            ID    : 'Suppliers',
            Target: 'Suppliers/@UI.LineItem#Suppliers',
        },

    ]
);


annotate service.Suppliers with @(UI.LineItem #Suppliers: [
    {
        $Type: 'UI.DataField',
        Value: ID,
        Label: 'Supplier ID',
    },
    {
        $Type                  : 'UI.DataField',
        Value                  : supplier,
        Label                  : 'Supplier',
        ![@Common.FieldControl]: #ReadOnly
    },
    {
        $Type: 'UI.DataField',
        Label: 'Name',
        Value: name,
    },
    {
        $Type                  : 'UI.DataField',
        Label                  : 'Open Amount',
        Value                  : amountopen,
        ![@Common.FieldControl]: #ReadOnly
    },
    {
        $Type                  : 'UI.DataField',
        Label                  : 'Closed Amount',
        Value                  : amountclose,
        ![@Common.FieldControl]: #ReadOnly
    },
    {
        $Type: 'UI.DataField',
        Value: modifiedAt,
    },
]);

annotate service.Suppliers with {
    name        @Common.FieldControl: #Mandatory;
    ID          @UI.Hidden;
    companycode @UI.Hidden;
};

annotate service.Suppliers with @(
    UI.FieldGroup #GeneratedGroup3: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Name',
                Value: name,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Block Supplier',
                Value: IsBlocked,
            },
            {
                $Type                  : 'UI.DataField',
                Label                  : 'Open Amount',
                Value                  : amountopen,
                ![@Common.FieldControl]: #ReadOnly
            },
            {
                $Type                  : 'UI.DataField',
                Label                  : 'Closing Amount',
                Value                  : amountclose,
                ![@Common.FieldControl]: #ReadOnly
            },
        ],
    },
    UI.Facets                     : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet3',
            Label : 'General Information',
            Target: '@UI.FieldGroup#GeneratedGroup3',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Addresses',
            ID    : 'Addresses',
            Target: 'addresses/@UI.LineItem#Addresses',
        },

    ]
);

annotate service.Suppliers with @(UI.HeaderInfo: {
    TypeName      : 'Supplier',
    TypeNamePlural: 'Suppliers',
    Title         : {
        $Type: 'UI.DataField',
        Value: name,
    },
    Description   : {
        $Type: 'UI.DataField',
        Value: supplier,
    },
});

//annotate service.Suppliers with @(UI.LineItem #Address: []);

annotate service.Addresses with @(UI.LineItem #Addresses: [
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
    },
]);

annotate service.Addresses with {
    country     @Common.FieldControl: #Mandatory;
    state       @Common.FieldControl: #Mandatory;
    zipcode     @Common.FieldControl: #Mandatory;
    address     @Common.FieldControl: #Mandatory;
    ID          @UI.Hidden;
    companycode @UI.Hidden;
    supplier    @UI.Hidden

};

annotate service.Addresses with @(
    UI.FieldGroup #GeneratedGroup2: {
        $Type: 'UI.FieldGroupType',
        Data : [
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
        ],
    },
    UI.Facets                     : [{
        $Type : 'UI.ReferenceFacet',
        ID    : 'GeneratedFacet2',
        Label : 'General Information',
        Target: '@UI.FieldGroup#GeneratedGroup2',
    }, ]
);

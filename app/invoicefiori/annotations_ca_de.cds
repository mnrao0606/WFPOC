using invoicesrv as service from '../../srv/Invoice';
using from './annotations';

annotate service.Invoices with @(Common.DefaultValuesFunction: 'getOrderDefaults');

annotate service.Invoices with @(UI.Identification: [
    {
        $Type        : 'UI.DataFieldForAction',
        Label        : 'Set to Post',
        Action       : 'invoicesrv.setOrderProcessing',
        ![@UI.Hidden]: {$edmJson: {$If: [
            {$Or: [
                {$Eq: [
                    {$Path: 'IsActiveEntity'},
                    false
                ]},
                {$Eq: [
                    {$Path: 'status'},
                    'Post'
                ]},
                {$Eq: [
                    {$Path: 'wfstatus'},
                    'WF Initiated'
                ]},
                {$Eq: [
                    {$Path: 'wfstatus'},
                    'In Approval'
                ]}
            ]},
            true,
            false
        ]}}
    },
    {
        $Type        : 'UI.DataFieldForAction',
        Label        : 'Set to Park',
        Action       : 'invoicesrv.setOrderOpen',
        ![@UI.Hidden]: {$edmJson: {$If: [
            {$Or: [
                {$Eq: [
                    {$Path: 'IsActiveEntity'},
                    false
                ]},
                {$Eq: [
                    {$Path: 'status'},
                    'Park'
                ]},
            ]},
            true,
            false
        ]}}
    },
    {
        $Type        : 'UI.DataFieldForAction',
        Label        : 'Request Information',
        Action       : 'invoicesrv.requestInfo',
        ![@UI.Hidden]: {$edmJson: {$If: [
            {$Or: [
                {$Eq: [
                    {$Path: 'IsActiveEntity'},
                    false
                ]},
                {$Eq: [
                    {$Path: 'status'},
                    'Post'
                ]},

                {$Eq: [
                    {$Path: 'wfstatus'},
                    'WF Initiated'
                ]},
                {$Eq: [
                    {$Path: 'wfstatus'},
                    'In Approval'
                ]}
            ]},
            true,
            false
        ]}}
    },
]);

annotate service.Invoices with @(UI.UpdateHidden: {$edmJson: {$Eq: [
    {$Path: 'status'},
    'Post'
]}});

annotate service.Invoices with {
    status @Common.FieldControl: {$edmJson: {$If: [
        {$Ne: [
            {$Path: 'status'},
            ''
        ]},
        1,
        3
    ]}}
};

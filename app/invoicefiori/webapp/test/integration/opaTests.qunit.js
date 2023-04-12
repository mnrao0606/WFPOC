sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'invoicefiori/test/integration/FirstJourney',
		'invoicefiori/test/integration/pages/InvoicesList',
		'invoicefiori/test/integration/pages/InvoicesObjectPage',
		'invoicefiori/test/integration/pages/InvoiceItemsObjectPage'
    ],
    function(JourneyRunner, opaJourney, InvoicesList, InvoicesObjectPage, InvoiceItemsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('invoicefiori') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheInvoicesList: InvoicesList,
					onTheInvoicesObjectPage: InvoicesObjectPage,
					onTheInvoiceItemsObjectPage: InvoiceItemsObjectPage
                }
            },
            opaJourney.run
        );
    }
);
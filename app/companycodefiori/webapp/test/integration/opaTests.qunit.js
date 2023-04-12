sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'companycodefiori/test/integration/FirstJourney',
		'companycodefiori/test/integration/pages/CompanyCodesList',
		'companycodefiori/test/integration/pages/CompanyCodesObjectPage',
		'companycodefiori/test/integration/pages/SuppliersObjectPage'
    ],
    function(JourneyRunner, opaJourney, CompanyCodesList, CompanyCodesObjectPage, SuppliersObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('companycodefiori') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheCompanyCodesList: CompanyCodesList,
					onTheCompanyCodesObjectPage: CompanyCodesObjectPage,
					onTheSuppliersObjectPage: SuppliersObjectPage
                }
            },
            opaJourney.run
        );
    }
);
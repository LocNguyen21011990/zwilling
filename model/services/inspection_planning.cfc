component {
    function getAllPlan() {
    	// return "aaa";
        return EntityLoad("inspection_planning");
    }
     function getPlan(inspection_planningid) {
    	// return "aaa";
        return EntityLoad("inspection_planning",{inspection_planningid = inspection_planningid},true);
    }
}

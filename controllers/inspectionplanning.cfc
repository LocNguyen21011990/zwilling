/**
*
* @file  /opt/lucee/webapps/zwilling/controllers/planning.cfc
* @author  
* @description
*
*/

component accessors=true  {
 	// property greetingService;
 	// variables.inspection_planningService
 	property inspection_planningService;
 	property purchase_orderService;

	public function init(required any fw){
		// SESSION.orders = [];
		variables.fw = arguments.fw;
		return this;
	}

	function list(struct rc ) {
 		rc.pagetitle = 'Inspection Plan';
		return;
	}

	public any function getAllPlan() {
		var plans = [];
		
		plans = VARIABLES.inspection_planningService.getAllPlan();
		variables.fw.renderData("Json", SerializeJSON(plans));	
	}
	

	public any function getPlan(struct rc) {
		 if(structKeyExists(rc, "planid")){
		 	var plan = VARIABLES.inspection_planningService.getPlan(rc.planid);
			variables.fw.renderData("Json", SerializeJSON(plan));	
		 }else{
		 	variables.fw.renderData("Json", "{}");	
		 }
		
	}
}
'use strict';

appServices.factory('documentItemService', function(ENV, $resource, $log, $http) {

    var api = ENV.domain + 'document_item.execute/:id';
    // var resource        = $resource(api);
    var resource = $resource(api, null, {
        'update': { method: 'PUT' }
    });
    return {
        getListTypeUpload: function() {
            return resource.query({}, function(res) {
                return res;
            });
        },
        getDocumentByType : function(code){
        	return $http.get(ENV.domain+'document_item.execute?codes='+ code).then(handeSuccess,handeError);
        },
        edit: function(documents) {
            return resource.update({}, documents);
        },
        getListKeyDocument: function(code){
            return $http.get(ENV.domain+'document_item.execute?code='+code).then(handeSuccess,handeError);
        }
    };

    function handeSuccess(res) {
        return res.data;
    }

    function handeError(res) {
        return function() {
            return { success: false, message: res.data['message'] || 'Error when get Location' };
        }
    }
});

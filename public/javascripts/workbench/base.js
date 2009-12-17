Ext.namespace('Ext.bio');
Ext.namespace('Ext.bio.workbench');



(function() {
  var originalGetCallData = Ext.direct.RemotingProvider.prototype.getCallData;

  Ext.override(Ext.direct.RemotingProvider, {
    getCallData: function(t) {
      var defaults = originalGetCallData.apply(this, arguments);

      return Ext.apply(defaults, {
        authenticity_token: FORM_AUTH_TOKEN
      });
    }
  })
})();


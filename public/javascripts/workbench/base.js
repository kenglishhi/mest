Ext.namespace('Ext.bio');
Ext.namespace('Ext.bio.workbench');

Ext.namespace('Ext.workbenchMenu');
Ext.namespace('Ext.workbenchdata');



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


Ext.workbenchMenu.blastHelpWindow = new Ext.Window({
  title: 'Blast Program Options',
  layout:'fit',
  width:500,
  height:300,
  closeAction:'hide',
  plain: true,
  items: new Ext.Panel({
    contentEl: 'blast-programs',
    autoScroll: true,
    deferredRender:false,
    border:false
  }),

  buttons: [{
    text: 'Close',
    handler: function(){
      Ext.workbenchMenu.blastHelpWindow.hide();
    }
  }]
});
if (!Ext.grid.GridView.prototype.templates) {
   Ext.grid.GridView.prototype.templates = {};
}
Ext.grid.GridView.prototype.templates.cell = new Ext.Template(
   '<td class="x-grid3-col x-grid3-cell x-grid3-td-{id} x-selectable {css}" style="{style}" tabIndex="0" {cellAttr}>',
   '<div class="x-grid3-cell-inner x-grid3-col-{id}" {attr}>{value}</div>',
   '</td>'
);
Ext.bio.BiodatabasePropertyGrid =  Ext.extend(Ext.grid.PropertyGrid, {
  title: 'Database Properties',
  closable: true,
  initComponent: function() {
    var parentComponentId = this.id;
    if (false) {
      this.restfulStore.load({
        params:{
          id:1
        },
        callback: function(store, records, options){
          var propGrid = Ext.getCmp(parentComponentId);
          if (propGrid) {
            propGrid.setSource(this.getAt(0).data);
          }
        }
      });
    }
    Ext.bio.BiodatabasePropertyGrid.superclass.initComponent.call(this);
    this.updateContent({});
  },
  updateContent: function(params) {
    var parentComponentId = this.id;
    if (params.biodatabase_id) {
      this.restfulStore.load({
        params:{
          id:params.biodatabase_id
        },
        callback: function(store, records, options){
          var propGrid = Ext.getCmp(parentComponentId);
          if (propGrid) {
            propGrid.setSource(this.getAt(0).data);
          }
        }
      });
    }
  },
  listeners: {
    afteredit: function (e) {
      var record = this.restfulStore.getAt(0);
      // We only allow them to update the name
      if (e.record.data.name  == "name") {
        var url_params = Ext.urlEncode({
          authenticity_token:FORM_AUTH_TOKEN
        });
        var params={};
        params = {
          id:record.id,
          data:{ name: e.record.data.value }
        };
        Ext.Ajax.request({
          url:"/workbench/biodatabases/" + record.id + ".json?" + url_params,
          headers: {
            'Content-Type':	'application/json'
          },
          method: 'PUT',
          params:  Ext.util.JSON.encode( params)
        });

      }
    }
  }
});

Ext.reg('biodatabase-property-grid', Ext.bio.BiodatabasePropertyGrid);

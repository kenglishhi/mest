Ext.bio.BiodatabasePropertyGrid =  Ext.extend(Ext.grid.PropertyGrid, {
  title: 'Database Properties',
  closable: true,
  initComponent: function() {
    Ext.bio.BiodatabasePropertyGrid.superclass.initComponent.call(this);
    this.updateContent({});
  },
  updateContent: function(params) {
    var parentComponentId = this.id;
    if (params.biodatabase_id) {
      var biodatabaseStore = new Ext.data.JsonStore( {
        restful:true,
        url:"/workbench/biodatabases/" + params.biodatabase_id + ".json",
        fields:[{
          "type":"string",
          "allowBlank":false,
          "name":"name"
        }],
        messageProperty:"message",
        root:"data",
        successProperty:"success",
        idProperty:"id",
        storeId:"biodatabase-show",
        autoLoad:true,
        listeners: {
          load: {
            fn: function(store, records, options){
              // get the property grid component
              var propGrid = Ext.getCmp(parentComponentId);
              // make sure the property grid exists
              if (propGrid) {
                // populate the property grid with store data
                propGrid.setSource(store.getAt(0).data);
              }
            }
          }
        }
      });
    }
  }
});

Ext.reg('biodatabase-property-grid', Ext.bio.BiodatabasePropertyGrid);

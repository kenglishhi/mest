
Ext.bio.DataPropertyGrid =  Ext.extend(Ext.grid.PropertyGrid, {
  title: 'Bio Property Grid',
  closable: true,
  id: 'bio-property-grid',
  initComponent: function() {

/*    var store = new Ext.data.JsonStore({"restful":true,
      "autoSave":true,
      "url":"/workbench/biosequences.json",
      "fields":[{"type":"int","allowBlank":true,"name":"id"},
        {"type":"string","allowBlank":false,"name":"name"},
       {"type":"string","allowBlank":true,"name":"alphabet"},
       {"type":"int","allowBlank":true,"name":"length"}],"messageProperty":"message","root":"data","successProperty":"success","idProperty":"id","storeId":"biosequence","autoLoad":false,writer:new Ext.data.JsonWriter({"encode":false})});;

*/
/*
    var propertyStore = new Ext.data.JsonStore({
      autoLoad: true,
      url: '/workbench/biodatabases/1.json',
      fields: ['id ', 'name', 'number_of_sequences'],
      root: "data"
    });
    */
//    propertyStore.load();

    Ext.bio.DataPropertyGrid.superclass.initComponent.call(this);

    var biodatabaseStore = new Ext.data.JsonStore(
    {"restful":true,
      "url":"/workbench/biodatabases/1.json",
      "fields":[{"type":"string","allowBlank":false,"name":"name"}],
      "messageProperty":"message",
      "root":"data",
      "successProperty":"success",
      "idProperty":"id",
      "storeId":"biodatabase-show",
      "autoLoad":true,
      writer:new Ext.data.JsonWriter({"encode":false}),
      listeners: {
            load: {
                fn: function(store, records, options){
                    // get the property grid component
                    var propGrid = Ext.getCmp('bio-property-grid');
                    console.log("Hello Kevin, loaded store");
                    // make sure the property grid exists
                    if (propGrid) {
                       console.log("Set Source");
                        // populate the property grid with store data
                        propGrid.setSource(store.getAt(0).data);
                    }
                }
            }
        }



}

  );


//    this.updateContent();
  },
  updateContent: function() {
     this.store.load();
  }
});
Ext.reg('data-property-grid', Ext.bio.DataPropertyGrid);


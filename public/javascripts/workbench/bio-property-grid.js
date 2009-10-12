Ext.bio.BiodatabasePropertyGrid =  Ext.extend(Ext.grid.PropertyGrid, {
  title: 'Database Properties',
  closable: true,
  initComponent: function() {
    //The traditional way
    var parentComponentId = this.id;
    // JsonReader
    var reader = new Ext.data.JsonReader({
      root: 'data',
      idProperty: 'id',
      successProperty: 'success'
    }, [{
      name: 'id'
    }, {
      name: 'name',
      allowBlank: true
    }, {
      name: 'number_of_sequences',
      allowBlank: true
    }]);
    // JsonWriter
    var writer = new Ext.data.JsonWriter({
      encode: false,
      writeAllFields: false
    });
    // HttpProxy
    var proxy = new Ext.data.HttpProxy({
      url:"/workbench/biodatabases.json"
    });
    // Typical Store
    var store = new Ext.data.Store({
      name: 'biodatabase-show-store',
      id: 'biodatabase-show-store',
      restful: true,
      proxy: proxy,
      reader: reader,
      writer: writer,
      autoLoad: false,
      autoSave: true,
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

    this.restfulStore = store ;
    this.restfulStore.load();

    //    Ext.apply(this,{
    //      bbar: [ {text: 'Save', handler: function(){ console.log("submit");} } ]
    //    });

    Ext.bio.BiodatabasePropertyGrid.superclass.initComponent.call(this);
    this.updateContent({});
  },
  updateContent: function(params) {
    return;
    var parentComponentId = this.id;
    if (params.biodatabase_id) {
      this.biodatabase_id =params.biodatabase_id;
      var biodatabaseStore = new Ext.data.JsonStore( {
        restful:true,
        url:"/workbench/biodatabases.json",
        fields:[{
          "type":"string",
          "allowBlank":false,
          "name":"name"
        }, {
          "type":"string",
          "allowBlank":false,
          "name":"number_of_sequences",
          editable: false
        }
        ],
        messageProperty:"message",
        root:"data",
        successProperty:"success",
        idProperty:"id",
        storeId:"biodatabase-show-store",
        autoLoad:false,
        writer:new Ext.data.JsonWriter({
          "encode":false
        }),
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
      this.restfulStore = biodatabaseStore ;
    } else {
      this.biodatabase_id = null;
    }
  },
  listeners: {
    afteredit: function (e) {
      var myStore = Ext.getCmp('biodatabase-show-store');
      console.log("After edit");
      var record = this.restfulStore.getAt(0);

      //      record.beginEdit();
      //      record.data.name="PEANUT";
      //      record.markDirty();
      //      record.endEdit();

      //      this.restfulStore.save();
      //      this.restfulStore.writer.update(record);
      //     console.log("After update");
      //      return;
      var propGridValues = this.store.getAt(0).data;
      var params={};
      params = {
        id:record.id
      };
      params.data={};
      params.data.name = "new_name"; //[ propGridValues.name] = propGridValues.value;
      params.data.id = this.biodatabase_id ;
      var url_params = Ext.urlEncode({
        authenticity_token:FORM_AUTH_TOKEN
      });
      console.log("url_params = " + url_params);

      var postData = {
        '_method': 'put',
        'data': {
          'name':'test name'
        },
        authenticity_token:FORM_AUTH_TOKEN
      };


      Ext.Ajax.request({
        url:"/workbench/biodatabases/" + record.id + ".json?" + url_params,
        //        method: 'POST',
        //        params: Ext.util.JSON.encode(postData)
        headers: {
          'Content-Type':	'application/json'
        },


        method: 'PUT',
        //        scope: this,
        params:  Ext.util.JSON.encode( params)
      //        params:  params
      });
    }
  }
});

Ext.reg('biodatabase-property-grid', Ext.bio.BiodatabasePropertyGrid);

/*!
 * Ext JS Library 3.0.0
 * Copyright(c) 2006-2009 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */

Ext.bio.RestfulGrid2 =  Ext.extend(Ext.grid.GridPanel, {
  prefix: null,
  dataUrl:null,
  displayColumns: [ ],
  readerColumns:[ ]
});


Ext.bio.RestfulGrid =  Ext.extend(Ext.grid.GridPanel, {
  prefix: null,
  dataUrl:null,
  displayColumns: [ ],
  readerColumns:[ ],
  useEditorFlag:false,
  initComponent: function() {
    var App = new Ext.App({});

    // Create a standard HttpProxy instance.
    var proxy = new Ext.data.HttpProxy({
      url: this.dataUrl
    });

    // Typical JsonReader.  Notice additional meta-data params for defining the core attributes of your json-response
    var reader = new Ext.data.JsonReader({
      successProperty: 'success',
      idProperty: 'id',
      root: 'data'
    }, this.readerColumns
    );

    // The new DataWriter component.
    var writer = new Ext.data.JsonWriter();

    // Typical Store collecting the Proxy, Reader and Writer together.

    var store = new Ext.data.Store({
      id: this.prefix+'-store',
      restful: true,     // <-- This Store is RESTful
      proxy: proxy,
      reader: reader,
      writer: writer,    // <-- plug a DataWriter into the store just as you would a Reader
      baseParams: {
        authenticity_token: FORM_AUTH_TOKEN
      },
      listeners: {
        write : function(store, action, result, response, rs) {
          App.setAlert(response.success, response.message);
        }
      }
    });

    // use RowEditor for editing
    var plugins = [];
    if (this.useEditorFlag){
      plugins[0] = this.editor;
      var editor = new Ext.ux.grid.RowEditor({
        saveText: 'Update'
      });
      plugins[0] = editor;
    }


    Ext.apply(this,{
      iconCls: 'icon-grid',
      frame: true,
      autoScroll: true,
      height: 300,
      store: store,
      plugins: plugins,
      columns : this.displayColumns,
      viewConfig: {
        forceFit: true
      }
    });

    Ext.bio.RestfulGrid2.superclass.initComponent.call(this);
  } ,
  listeners: {
    render: function( p)  {
      console.log("they called render")
      this.store.load();
    }
  }
});


Ext.bio.BiodatabaseGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  prefix: 'biodatabase-store',
  dataUrl: '/workbench/biodatabases',
  useEditorFlag:true,
  displayColumns:  [ {
      header: "ID",
      width: 40,
      sortable: true,
      dataIndex: 'id'
    }, {
      header: "Name",
      width: 100,
      sortable: true,
      dataIndex: 'name',
      editor: new Ext.form.TextField({})
    } ],
  readerColumns: [ { name: 'id' }, { name: 'name', allowBlank: false } ] ,
  initComponent: function() {
    Ext.bio.BiodatabaseGrid.superclass.initComponent.call(this);
  } 
});
Ext.reg('biodatabase-grid', Ext.bio.BiodatabaseGrid);

Ext.bio.BiodatabaseGroupGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  prefix: 'biodatabase-group-store',
  dataUrl: '/workbench/biodatabase_groups',
  useEditorFlag:true,
  displayColumns:  [ {
      header: "ID",
      width: 40,
      sortable: true,
      dataIndex: 'id'
    }, {
      header: "Name",
      width: 100,
      sortable: true,
      dataIndex: 'name',
      editor: new Ext.form.TextField({})
    } ],
  readerColumns: [ { name: 'id' }, { name: 'name', allowBlank: false } ] ,
  initComponent: function() {
    Ext.bio.BiodatabaseGroupGrid.superclass.initComponent.call(this);
  } 
});
Ext.reg('biodatabase-group-grid', Ext.bio.BiodatabaseGroupGrid);


Ext.bio.BiosequenceGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  prefix: 'biosequences',
  dataUrl: '/workbench/biosequences',
  displayColumns: [
  {
    header: "ID",
    width: 40,
    sortable: true,
    dataIndex: 'id'
  }, {
    header: "Name",
    width: 100,
    sortable: true,
    dataIndex: 'name'
  }, {
    header: "Length",
    width: 10,
    sortable: true,
    dataIndex: 'length'

  }
  ],
  readerColumns:[
  {
    name: 'id'
  } , {
    name: 'name',
    allowBlank: false
  } , {
    name: 'length'
  }
  ],

  initComponent: function() {
    Ext.bio.BiosequenceGrid.superclass.initComponent.call(this);
  }
});
Ext.reg('biosequence-grid', Ext.bio.BiosequenceGrid);
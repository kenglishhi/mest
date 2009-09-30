/*!
 * Ext JS Library 3.0.0
 * Copyright(c) 2006-2009 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */

Ext.bio.RestfulGrid =  Ext.extend(Ext.grid.GridPanel, {
  });

Ext.bio.BiodatabaseGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  initComponent: function() {
    var App = new Ext.App({});

    // Create a standard HttpProxy instance.
    var proxy = new Ext.data.HttpProxy({
      url: '/workbench/biodatabases'
    });

    // Typical JsonReader.  Notice additional meta-data params for defining the core attributes of your json-response
    var reader = new Ext.data.JsonReader({
      totalProperty: 'total',
      successProperty: 'success',
      idProperty: 'id',
      root: 'data'
    }, [
    {
      name: 'id'
    },
    {
      name: 'name',
      allowBlank: false
    }
    ]);

    // The new DataWriter component.
    var writer = new Ext.data.JsonWriter();

    // Typical Store collecting the Proxy, Reader and Writer together.

    var store = new Ext.data.Store({
      id: 'biodatabase-store',
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

    // Let's pretend we rendered our grid-columns with meta-data from our ORM framework.
    var biodatabaseColumns =  [
    {
      header: "ID",
      width: 40,
      sortable: true,
      dataIndex: 'id'
    },
    {
      header: "Name",
      width: 100,
      sortable: true,
      dataIndex: 'name',
      editor: new Ext.form.TextField({})
    }
    ];

    // load the store immeditately
    //    store.load();

    // Create a typical GridPanel with RowEditor plugin
    // use RowEditor for editing
    var editor = new Ext.ux.grid.RowEditor({
      saveText: 'Update'
    });

    Ext.apply(this,{
      iconCls: 'icon-grid',
      frame: true,
      autoScroll: true,
      height: 300,
      store: store,
      plugins: [editor],
      columns : biodatabaseColumns,
      tbar: [{
        text: 'Add',
        iconCls: 'silk-add',
        handler: onAdd
      }, '-', {
        text: 'Delete',
        iconCls: 'silk-delete',
        handler: onDelete
      }, '-'],
      viewConfig: {
        forceFit: true
      }
    });

    /**
     * onAdd
     */
    var myGrid = this;
    function onAdd(btn, ev) {
      var u = new myGrid.store.recordType({
        first : '',
        last: '',
        email : ''
      });
      editor.stopEditing();
      myGrid.store.insert(0, u);
      editor.startEditing(0);
    }
    /**
     * onDelete
     */
    function onDelete() {
      var rec = myGrid.getSelectionModel().getSelected();
      if (!rec) {
        return false;
      }
      myGrid.store.remove(rec);
    }


    Ext.bio.BiodatabaseGrid.superclass.initComponent.call(this);
  } ,
  listeners: {
    render: function( p)  {
      console.log("they called activate")
      this.store.load();
    }
  }

});
Ext.reg('biodatabase-grid', Ext.bio.BiodatabaseGrid);

Ext.bio.BiodatabaseGroupGrid =  Ext.extend(Ext.bio.RestfulGrid, {

  initComponent: function() {
    var App = new Ext.App({});

    // Create a standard HttpProxy instance.
    var proxy = new Ext.data.HttpProxy({
      url: '/workbench/biodatabase_groups'
    });

    // Typical JsonReader.  Notice additional meta-data params for defining the core attributes of your json-response
    var reader = new Ext.data.JsonReader({
      totalProperty: 'total',
      successProperty: 'success',
      idProperty: 'id',
      root: 'data'
    }, [
    {
      name: 'id'
    },
    {
      name: 'name',
      allowBlank: false
    }
    ]);

    // The new DataWriter component.
    var writer = new Ext.data.JsonWriter();

    // Typical Store collecting the Proxy, Reader and Writer together.

    var store = new Ext.data.Store({
      id: 'biodatabase-group-store',
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

    // Let's pretend we rendered our grid-columns with meta-data from our ORM framework.
    var biodatabaseColumns =  [
    {
      header: "ID",
      width: 40,
      sortable: true,
      dataIndex: 'id'
    },
    {
      header: "Name",
      width: 100,
      sortable: true,
      dataIndex: 'name',
      editor: new Ext.form.TextField({})
    }
    ];

    // load the store immeditately
//    store.load();

    // Create a typical GridPanel with RowEditor plugin
    // use RowEditor for editing
    var editor = new Ext.ux.grid.RowEditor({
      saveText: 'Update'
    });

    Ext.apply(this,{
      iconCls: 'icon-grid',
      frame: true,
      autoScroll: true,
      height: 300,
      store: store,
      plugins: [editor],
      columns : biodatabaseColumns,
      /*      tbar: [{
        text: 'Add',
        iconCls: 'silk-add',
        handler: onAdd
      }, '-', {
        text: 'Delete',
        iconCls: 'silk-delete',
        handler: onDelete
      }, '-'],
      */
      viewConfig: {
        forceFit: true
      }
    });

    /**
     * onAdd
     */
    var myGrid = this;
    /*    function onAdd(btn, ev) {
      var u = new myGrid.store.recordType({
        first : '',
        last: '',
        email : ''
      });
      editor.stopEditing();
      myGrid.store.insert(0, u);
      editor.startEditing(0);
    }
    */
    /**
     * onDelete
     */
    /*
    function onDelete() {
      var rec = myGrid.getSelectionModel().getSelected();
      if (!rec) {
        return false;
      }
      myGrid.store.remove(rec);
    }
    */


    Ext.bio.BiodatabaseGroupGrid.superclass.initComponent.call(this);
  } ,
  listeners: {
    render: function( p)  {
      console.log("they called activate")
      this.store.load();
    }
  }
 
});
Ext.reg('biodatabase-group-grid', Ext.bio.BiodatabaseGroupGrid);

Ext.bio.RestfulGrid2 =  Ext.extend(Ext.grid.GridPanel, {
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

    //    store.load();

    // Create a typical GridPanel with RowEditor plugin
    // use RowEditor for editing
    var plugins = [];
    if (this.use_editor){
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
      console.log("they called activate")
      this.store.load();
    }
  }


});


Ext.bio.BiosequenceGrid =  Ext.extend(Ext.bio.RestfulGrid2, {
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
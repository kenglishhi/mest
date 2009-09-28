/*!
 * Ext JS Library 3.0.0
 * Copyright(c) 2006-2009 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
// Application instance for showing user-feedback messages.
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
    {name: 'id'},
    {name: 'name', allowBlank: false},
    {name: 'user_id', allowBlank: false}
]);

// The new DataWriter component.
var writer = new Ext.data.JsonWriter();

// Typical Store collecting the Proxy, Reader and Writer together.
var store = new Ext.data.Store({
    id: 'biodatabase',
    restful: true,     // <-- This Store is RESTful
    proxy: proxy,
    reader: reader,
    writer: writer,    // <-- plug a DataWriter into the store just as you would a Reader
    listeners: {
        write : function(store, action, result, response, rs) {
            App.setAlert(response.success, response.message);
        }
    }
});

// Let's pretend we rendered our grid-columns with meta-data from our ORM framework.
var biodatabaseColumns =  [
    {header: "ID", width: 40, sortable: true, dataIndex: 'id'},
    {header: "Name", width: 100, sortable: true, dataIndex: 'name', editor: new Ext.form.TextField({})},
    {header: "User Id", width: 50, sortable: true, dataIndex: 'user_id', editor: new Ext.form.TextField({})}
];

// load the store immeditately
store.load();
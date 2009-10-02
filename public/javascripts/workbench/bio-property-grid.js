
Ext.bio.DataPropertyGrid =  Ext.extend(Ext.grid.PropertyGrid, {
  title: 'Property Grid',
  closable: true,
  source: {
    "(name)": "Properties Grid",
    "grouping": false,
    "autoFitColumns": true,
    "productionQuality": false,
    "created": new Date(Date.parse('10/15/2006')),
    "tested": false,
    "version": 0.01,
    "borderWidth": 1
  },
  initComponent: function() {
    var propertyStore = new Ext.data.JsonStore({
      autoLoad: true,  //autoload the data
      url: 'getproperties.php',
      root: 'props',
      fields: ['First name', 'Last name', 'E-mail'],
      listeners: {
        load: {
          fn: function(store, records, options){
            // get the property grid component
            var propGrid = Ext.getCmp('propGrid');
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
});
Ext.reg('data-property-grid', Ext.bio.DataPropertyGrid);


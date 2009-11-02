/*!
 * bio-grids.js
 * Kevin English, University of Hawaii
 */
Ext.bio.SeqSearchField = Ext.extend(Ext.form.TwinTriggerField, {
  initComponent : function(){
    Ext.bio.SeqSearchField.superclass.initComponent.call(this);
    this.on('specialkey', function(f, e){
      if(e.getKey() == e.ENTER){
        this.onTrigger2Click();
      }
    }, this);
  },

  validationEvent:false,
  validateOnBlur:false,
  trigger1Class:'x-form-clear-trigger',
  trigger2Class:'x-form-search-trigger',
  hideTrigger1:true,
  width:180,
  hasSearch : false,
  paramName : 'query',

  onTrigger1Click : function(){
    if(this.hasSearch){
      this.el.dom.value = '';
      var o = {
        start: 0
      };
      this.store.baseParams = this.store.baseParams || {};
      this.store.baseParams[this.paramName] = '';
      this.store.reload({
        params:o
      });
      this.triggers[0].hide();
      this.hasSearch = false;
    }
  },

  onTrigger2Click : function(){
    var v = this.getRawValue();
    if(v.length < 1){
      this.onTrigger1Click();
      return;
    }
    var o = {
      start: 0
    };
    this.store.baseParams = this.store.baseParams || {};
    this.store.baseParams[this.paramName] = v;
    this.store.reload({
      params:o
    });
    this.hasSearch = true;
    this.triggers[0].show();
  }
});

Ext.bio.BiosequenceGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  pageSize: 50,
  biosequenceViewId: 'xxxx',
  usePagingBarFlag: true,
  displayColumns: [
  {
    header: "Name",
    sortable: true,
    autoWidth: true,
    dataIndex: 'name'
  }, {
    header: "Length",
    autoWidth: true,
    sortable: true,
    dataIndex: 'length'
  }
  ],
  initComponent: function() {

    var biosequenceViewId = this.biosequenceViewId;
    this.store.on('load',function() {
      var viewPanel = Ext.getCmp(biosequenceViewId);
      if (viewPanel) {
        var params = {
          rowIndex: 0
        };
        viewPanel.updateContent(params);
      }

    });

    Ext.apply(this,{
      tbar:[
      'Search: ', ' ',
      new Ext.bio.SeqSearchField({
        store: this.store,
        width:320
      })
      ]
    });

    Ext.bio.BiosequenceGrid.superclass.initComponent.call(this);
  },
  listeners: {
    afterrender: function( p)  {
      var viewPanel = Ext.getCmp(this.biosequenceViewId);
      viewPanel.setSource(this.store);
    },
    rowclick: function (grid, rowIndex, e) {
      var viewPanel = Ext.getCmp(this.biosequenceViewId);
      var params = {
        rowIndex: rowIndex
      };
      var biosequenceViewId;
      viewPanel.updateContent(params);
    }
  },
  updateContent: function(params) {
    this.store.baseParams.biodatabase_id = params.biodatabase_id;
    var viewPanel = Ext.getCmp(this.biosequenceViewId);
    this.store.load({
      params: {
        start: 0,
        limit: this.pageSize
      }
    } );
  }

});
Ext.reg('biosequence-grid', Ext.bio.BiosequenceGrid);

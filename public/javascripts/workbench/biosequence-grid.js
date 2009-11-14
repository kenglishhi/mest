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
  width:50,
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
  },{
    header: "Action",
    css: 'background-image:url(/images/delete.gif) !important; background-repeat:no-repeat; text-align:right;font-weight:bold; ',
    width: 2,
    resizable: false,
    sortable: true,
    renderer: function() {
      return "Delete";
    }
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
    var cmpId = this.id;

    Ext.apply(this,{
      tbar:[       'Search: ', ' ',
      new Ext.bio.SeqSearchField({
        store: this.store,
        width:200
      }),
      '->', {
        iconCls:'new_fasta',
        text: 'Fasta File',
        id:'seq-grid-fasta-toolbar-item',
        hidden: true,
        handler: function() {
          var strUrl = Ext.getCmp(cmpId).biodatabasePropertyStore.getAt(0).data.fasta_file_url;
          window.open(strUrl);
        }
      },'-',
      {
        iconCls:'clustalw',
        text: 'Alignment File',
        id:'seq-grid-alignment-toolbar-item',
        hidden: true,
        labelStyle: 'font-weight:bold;',
        handler: function() {
          var strUrl = Ext.getCmp(cmpId).biodatabasePropertyStore.getAt(0).data.alignment_file_url;
          window.open(strUrl);
        }
      }
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
    },
    cellclick: function (grid, rowIndex,columnIndex, e) {
      var fieldName = grid.getColumnModel().getColumnHeader(columnIndex);
      if (fieldName == 'Action'){
        var rec = grid.store.getAt(rowIndex); // getSelectionModel().getSelected();
        if (!rec) {
          return false;
        }
        grid.store.remove(rec);
        grid.store.reload();
      }
    }

  },
  updateContent: function(params) {
    if (params.biodatabase_id) {
      this.store.baseParams.biodatabase_id = params.biodatabase_id;
      var viewPanel = Ext.getCmp(this.biosequenceViewId);
      this.store.load({
        params: {
          start: 0,
          limit: this.pageSize
        }
      } );
      this.biodatabasePropertyStore.load({
        params:{
          id:params.biodatabase_id
        },
        callback: function(store, records, options){
          if (this.getAt(0).data.fasta_file_url){
            Ext.getCmp('seq-grid-fasta-toolbar-item').show();
          } else {
            Ext.getCmp('seq-grid-fasta-toolbar-item').hide();
          }
          if (this.getAt(0).data.alignment_file_url){
            Ext.getCmp('seq-grid-alignment-toolbar-item').show();
          } else {
            Ext.getCmp('seq-grid-alignment-toolbar-item').hide();
          }

        //          var propGrid = Ext.getCmp(parentComponentId);
        //          if (propGrid) {
        //            propGrid.setSource(this.getAt(0).data);
        //          }
        }
      });
    }
  }
});
Ext.reg('biosequence-grid', Ext.bio.BiosequenceGrid);

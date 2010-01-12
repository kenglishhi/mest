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
  biosequenceViewPanelId: 'xxxx',
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
    var biosequenceViewPanelId = this.biosequenceViewPanelId;
    this.store.on('load',function() {
      var viewPanel = Ext.getCmp(biosequenceViewPanelId);
      if (viewPanel) {
        var params = {
          rowIndex: 0
        };
      }
    });
    var cmpId = this.id;

    function onDelete() {
      var grid = Ext.getCmp(cmpId);
      grid.deleteSelectedRow(true,'name',function(params) {
        grid.updateViewPanel({
          rowIndex: params.rowIndex
        });
      });
    }
    Ext.apply(this,{
      tbar:[       'Search: ', ' ',
      new Ext.bio.SeqSearchField({
        store: this.store,
        width:200
      }),
      {
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
        text: 'View Alignment',
        id:'seq-grid-alignment-toolbar-item',
        hidden: false,
        labelStyle: 'font-weight:bold;',
        alignmentViewPanelId: this.alignmentViewPanelId,
        handler: function() {
          var strUrl = Ext.getCmp(cmpId).biodatabasePropertyStore.getAt(0).data.alignment_file_url;
          var alignmentViewPanel = Ext.getCmp(this.alignmentViewPanelId);
          if (alignmentViewPanel) { 
            alignmentViewPanel.updateContent({
              url: strUrl
            });
          }
        //          alignemExt.getCmp(this.alignmentViewPanelId).updateContent(strUrl);
        //          window.open(strUrl);
        }
      }
      , '->', {
        text: 'Delete',
        iconCls:'x-tree-delete',
        handler: onDelete
      }
      ]
    });

    Ext.bio.BiosequenceGrid.superclass.initComponent.call(this);
  },
  updateViewPanel: function(params) {
    var viewPanel = Ext.getCmp(this.biosequenceViewPanelId);
    viewPanel.updateContent(params);
  },
  listeners: {
    afterrender: function( p)  {
      var viewPanel = Ext.getCmp(this.biosequenceViewPanelId);
      viewPanel.setSource(this.store);
    },
    rowclick: function (grid, rowIndex, e) {
      var params = {
        rowIndex: rowIndex
      };
      grid.updateViewPanel(params);
    },
    cellclick: function (grid, rowIndex,columnIndex, e) {
      var fieldName = grid.getColumnModel().getColumnHeader(columnIndex);
      if (fieldName == 'Action'){
        var rec = grid.store.getAt(rowIndex); // getSelectionModel().getSelected();
        if (rec) {
          Ext.MessageBox.confirm('Confirm', 'Are you sure you want to delete "' + rec.data.name +'"?',
            function(btn){
              if (btn == 'yes') {
                grid.store.remove(rec);
                grid.selModel.selectRow(rowIndex);
                grid.updateViewPanel({
                  rowIndex: rowIndex
                });
              }
            });
          return false;
        }
      }
    }

  },
  updateContent: function(params) {
    if (params.biodatabase_id) {
      this.store.baseParams.biodatabase_id = params.biodatabase_id;
      this.store.load({
        params: {
          start: 0,
          limit: this.pageSize
        }
      } );
      var alignmentViewPanelId = this.alignmentViewPanelId;
      this.biodatabasePropertyStore.load({
        params:{
          id:params.biodatabase_id
        },
        callback: function(store, records, options){
          var tbFasta = Ext.getCmp('seq-grid-fasta-toolbar-item');
          var tbAlign = Ext.getCmp('seq-grid-alignment-toolbar-item');
          if (tbFasta) {
            if (this.getAt(0).data.fasta_file_url){
              tbFasta.show();
            } else {
              tbFasta.hide();
            }
          }
          // Update the alignment page..
          var alignmentViewPanel = Ext.getCmp(alignmentViewPanelId );
          if (this.getAt(0).data.alignment_file_url){

            tbAlign.show();
            if (alignmentViewPanel) {
              alignmentViewPanel.updateContent({
                biodatabase_id: params.biodatabase_id,
                biodatabase_name: params.biodatabase_name
              });
            }
          } else {
            tbAlign.hide();
            alignmentViewPanel.clearContent();
          }
        }
      });
    }
  },
  clearContent : function() {
    this.store.reload();
  }

});
Ext.reg('biosequence-grid', Ext.bio.BiosequenceGrid);

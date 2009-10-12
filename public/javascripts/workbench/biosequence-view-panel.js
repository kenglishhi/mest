/*  $Id: sequence_text.js 10550 2009-09-08 20:29:29Z rallj $
 * ===========================================================================
 *
 *                            PUBLIC DOMAIN NOTICE
 *               National Center for Biotechnology Information
 *
 *  This software/database is a "United States Government Work" under the
 *  terms of the United States Copyright Act.  It was written as part of
 *  the author's official duties as a United States Government employee and
 *  thus cannot be copyrighted.  This software/database is freely available
 *  to the public for use. The National Library of Medicine and the U.S.
 *  Government have not placed any restriction on its use or reproduction.
 *
 *  Although all reasonable efforts have been taken to ensure the accuracy
 *  and reliability of the software and data, the NLM and the U.S.
 *  Government do not and cannot warrant the performance or results that
 *  may be obtained by using this software or data. The NLM and the U.S.
 *  Government disclaim all warranties, express or implied, including
 *  warranties of performance, merchantability or fitness for any particular
 *  purpose.
 *
 *  Please cite the author in any work or product based on this material.
 *
 * ===========================================================================
 *
 * Authors:  Vlad Lebedev
 *
 * File Description: Sequence View Panel
 * Modified from sequence_text.js by Kevin English
 *
 */


Ext.bio.gotoSequencePrev=  function(obj,e) {
  var grid =  Ext.getCmp(this.viewPanelId);
  if (grid) {
    var newIndex =grid.selectedRowIndex-1;
    grid.updateContent({
      rowIndex: newIndex
    });
  }
};

Ext.bio.gotoSequenceNext = function(obj,e) {
  var grid =  Ext.getCmp(this.viewPanelId);
  if (grid) {
    var newIndex =grid.selectedRowIndex+1;
    grid.updateContent({
      rowIndex: newIndex
    });
  }
};


Ext.bio.BiosequenceViewPanel =  Ext.extend(Ext.Panel, {
  initComponent: function() {
    Ext.apply(this,{
      items:[{
        xtype:'panel',
        autoScroll: true,
        id:'seq-panel',
        layout:'fit',
        sequenceViewTmpl: new Ext.Template(
          '<table width="{width}" class="fasta-table" style="border-style:solid;border-width:{border}px;" ><tbody><tr bordercolor="#ffffff"><td id="left_sequence" width=50 valign="top" align="right"><br><em>{left_nums}</em></td>',
          '<td valign="top"><span id="top_sequence"><em>{topNums}</em></span><br/><div id="text_sequence">{sequence}</div></td>',
          '</tr></tbody></table>'
          ),
        html: "Sequence Preview Here",
        listeners: {
          afterrender: function(){
            var sequenceCols = 100;
            var topNums = "";
            for (i = 0; i != sequenceCols / 10; i++) {
              topNums += '123456789<span>0</span>';
            }

            var html = Ext.getCmp('seq-panel').sequenceViewTmpl.apply(
            {
              border:0,
              width:'95%',
              left_nums:"0<br/>100<br/>200<br/>300<br/>400<br/>500<br/>",
              topNums:topNums,
              sequence:""
            });
            Ext.getCmp('seq-panel').getEl().update(html);

          }
        }
      }],
      title: 'View Sequence',
      tbar:[
      {
        iconCls:'new_fasta',
        text:'Seq',
        id: 'tbar-item-sequence-title'
      },
      '->',
      {
        text:'Prev Sequence',
        iconCls:'prev',
        handler:Ext.bio.gotoSequencePrev,
        viewPanelId: this.id
      },'-',

      {
        text:'Next Sequence',
        iconCls:'next',
        handler:Ext.bio.gotoSequenceNext,
        viewPanelId: this.id
      }
      ]
    });
   Ext.bio.BiosequenceViewPanel.superclass.initComponent.call(this);
  //    this.updateContent();

  },

  updateContent: function(params) {
    if (typeof(params.rowIndex) == "undefined") {
      params.rowIndex = 0;
    } else if (params.rowIndex < 0) {
      params.rowIndex = this.store.data.items.length-1;
    }
    else if  (params.rowIndex >= this.store.data.items.length) {
      params.rowIndex = 0;
    }
    this.selectedRowIndex = params.rowIndex;
    //var record = this.store.data.items[params.rowIndex].data ;
    var record = this.store.getAt(params.rowIndex).data ;

    Ext.getCmp('tbar-item-sequence-title').setText("Sequence <b>" + record.name + "</b>");
    var sequenceCols = 100;
    var sequenceRows = Math.floor(record.length / sequenceCols) + 1;

    var starts = "";
    var sequence = "";

    for (var i=0;  i< sequenceRows; i++) {
      var startPosition = (i * sequenceCols) ;
      starts += startPosition + "<br/>";
      sequence += "<div class='sequence'><span id='ttl-id1' class='feat-cds' rel='1'>" +
      record.seq.substring(startPosition, startPosition  + sequenceCols) +
      "</span></div>";
    }
    var topNums = "";
    for (i = 0; i != sequenceCols / 10; i++) {
      topNums += '123456789<span>0</span>';
    }

    var html = Ext.getCmp('seq-panel').sequenceViewTmpl.apply(
    {
      border:0,
      width:'95%',
      left_nums:starts,
      topNums:topNums,
      sequence:sequence
    });
    Ext.getCmp('seq-panel').getEl().update(html);
  },
  listeners: {
  },
  setSource: function(s){
    this.store = s;
  }
});
Ext.reg('biosequence-view-panel', Ext.bio.BiosequenceViewPanel);

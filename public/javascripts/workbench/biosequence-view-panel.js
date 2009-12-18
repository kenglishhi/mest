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
        title: 'View Sequence',
        autoScroll: true,
        id:'seq-panel',
        sequenceViewTmpl: new Ext.Template(
        '<div width="{width}" class="fasta-seq-name"  ><b>Name:</b> {seq_name} </div>',
          '<table width="{width}" class="fasta-table" style="border-style:solid;border-width:{border}px;" >',
          '<tbody><tr bordercolor="#ffffff"><td id="left_sequence" width=50 valign="top" align="right"><br><em>{left_nums}</em></td>',
          '<td valign="top"><span id="top_sequence"><em>{topNums}</em></span><br/><div id="text_sequence">{sequence}</div></td>',
          '</tr></tbody></table>'
          ),
        html: "Sequence Preview Here",
        listeners: {
          afterrender: function(){
            var sequenceCols = 100;
            var topNums = "";
            var i;
            for (i = 0; i != sequenceCols / 10; i++) {
              topNums += '123456789<span>0</span>';
            }

            var html = Ext.getCmp('seq-panel').sequenceViewTmpl.apply(
            {
              border:0,
              width:'95%',
              left_nums:"0<br/>100<br/>200<br/>300<br/>400<br/>500<br/>",
              topNums:topNums,
              sequence:"",
              seq_name: ""
            });
            Ext.getCmp('seq-panel').getEl().update(html);

          }
        }
      }],
      tbar:[
      {
        text:'Seq',
        id: 'tbar-item-sequence-title'
      },
      {
        iconCls:'zoom_minus',
        text:'Blast @ NCBI',
        id: 'tbar-ncbi-blast',
        viewPanelId: this.id,
        disabled: true ,
        handler: function() {
          var record = Ext.getCmp(this.viewPanelId).record;
          if (record) {
            var params = {};
            params.JOB_TITLE = 'MEST-'+record.name;
            params.QUERY     = record.seq;
            Ext.bio.ncbiBlastSearch(params);
          }
        }
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
    this.record = record;

    Ext.getCmp('tbar-item-sequence-title').setText("Sequence <b>" + record.name.substr(0,50) + "</b>");
    var sequenceCols = 100;
    var sequenceRows = Math.floor(record.length / sequenceCols) + 1;

    var starts = "";
    var sequence = "";

    for (var i=0;  i< sequenceRows; i++) {
      var startPosition = (i * sequenceCols) ;
      starts += startPosition + "<br/>";
      var my_seq = record.seq.substring(startPosition, startPosition  + sequenceCols);
      my_seq = my_seq.toUpperCase();
      my_seq = my_seq.replace(/(A+)/g, "<span class='dna-a'>$1</span>");
      my_seq = my_seq.replace(/(T+)/g, "<span class='dna-t'>$1</span>");
      my_seq = my_seq.replace(/(C+)/g, "<span class='dna-c'>$1</span>");
      //      '<span class="dna-a">' + my_seq + '</span>';
      sequence += "<div class='sequence'><span id='ttl-id1' class='feat-cds' rel='1'>" +
      my_seq +
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
      sequence:sequence,
      seq_name: record.name
    });
    Ext.getCmp('seq-panel').getEl().update(html);
    Ext.getCmp('tbar-ncbi-blast').enable();
  },
  listeners: {
  },
  setSource: function(s){
    this.store = s;
  }
});
Ext.reg('biosequence-view-panel', Ext.bio.BiosequenceViewPanel);

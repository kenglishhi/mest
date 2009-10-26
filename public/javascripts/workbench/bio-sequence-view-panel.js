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
Ext.bio.ncbiBlastSearch = function (node_id,params) {

  var baseParams = {};
  baseParams.ALIGNMENT_VIEW = "Pairwise";
  baseParams.ALIGNMENTS = "100";
  baseParams.ALIGNMENT_VIEW ='';
  baseParams.BLAST_PROGRAMS = 'blastn';
  baseParams.BLAST_SPEC = "";
  baseParams.CLIENT = "web";
  baseParams.CMD = "request" ;
  baseParams.COMPOSITION_BASED_STATISTICS  = ''
  baseParams.DATABASE = 'nr';
  baseParams.db = 'nucleotide'
  baseParams.DB_ABBR = "";
  baseParams.DB_DIR_PREFIX="";
  baseParams.DBTYPE = 'gc';
  baseParams.DEFAULT_PROG = "megaBlast";
  baseParams.DESCRIPTIONS = "100";
  baseParams.EQ_MENU  = ''
  baseParams.EQ_TEXT = ''
  baseParams.EXCLUDE_MODELS  = 'on'
  baseParams.EXCLUDE_SEQ_UNCULT = 'on'
  baseParams.EXPECT = '25';
  baseParams.EXPECT_HIGH="";
  baseParams.EXPECT_LOW="";
  baseParams.FILTER = ''
  baseParams.FORMAT_EQ_TEXT="";
  baseParams.FORMAT_OBJECT = "Alignment";
  baseParams.FORMAT_ORGANISM="";
  baseParams.FORMAT_TYPE = "HTML";
  baseParams.GAPCOSTS = ''
  baseParams.GENETIC_CODE = ''
  baseParams.GET_SEQUENCE = true;
  baseParams.I_THRESH = "";
  baseParams.JOB_TITLE = 'MaybeHiVxxxxxxyyyy';
  baseParams.LCASE_MASK  = 'on'
  baseParams.MASK_CHAR = "2";
  baseParams.MASK_COLOR ="1";
  baseParams.MATCH_SCORES = '1,-2';
  baseParams.MATRIX_NAME = ''
  baseParams.MAX_NUM_SEQ  = '20'
  baseParams.MEGABLAST = "on" ;
  baseParams.NCBI_GI=false;
  baseParams.NEW_VIEW =true;
  baseParams.NEWWIN = 'on'
  baseParams.NO_COMMON="";
  baseParams.NUM_DIFFS="1";
  baseParams.NUM_OPTS_DIFFS="0";
  baseParams.NUM_ORG  = '1'
  baseParams.NUM_OVERVIEW="100";
  baseParams.OLD_BLAST=false;
  baseParams.ORG_EXCLUDE  = ''
  baseParams.PAGE = "MegaBlast" ;
  baseParams.PAGE_TYPE="BlastSearch";
  baseParams.PHI_PATTERN  = ''
  baseParams.PROGRAM = "blastn" ;
  baseParams.PSSM = ''
  baseParams.QUERY = "GAAGAGATAGTAATTAGATCTGCCAATTTCACAGACAATGCTAAAATCATAATAGTACAGCTAAATGCATCTGTAGAAATTAATTGTACAAGACCCAACAACAATACAAGAAAAGGTATAAATATAGGACCAGGGAGGGCATTTTATGCAACAGGAGGAATAATAGGAGATATAAGACAAGCACATTGTAACATTAGTGAGGAAAAATGGAATAATACTTTAAAACAGGTAGTTACAAAATTAAGAGAACAATTTGGGAATAAAACAATAATCTTCAATCACTCCTCAGGAGGGGACCCAGAAATTGT";
  baseParams.QUERY_BELIEVE_DEFLINE="";
  baseParams.QUERY_FROM = ''
  baseParams.QUERY_INDEX = "";
  baseParams.QUERY_TO = ''
  baseParams.QUERYFILE = ''
  baseParams.REPEATS = ''
  baseParams.RUN_PSIBLAST = "" ;
  baseParams.SAVED_PSSM="";
  baseParams.SAVED_SEARCH=true;
  baseParams.SELECTED_PROG_TYPE="megaBlast";
  baseParams.SERVICE = "plain";
  baseParams.SHORT_QUERY_ADJUST  = ''
  baseParams.SHOW_CDS_FEATURE=false;
  baseParams.SHOW_LINKOUT= true;
  baseParams.SHOW_OVERVIEW = true;
  baseParams.stype = 'nucleotide';
  baseParams.SUBJECTFILE = ''
  baseParams.SUBJECTS = ''
  baseParams.SUBJECTS_FROM = ''
  baseParams.SUBJECTS_TO = ''
  baseParams.TEMPLATE_LENGTH = ''
  baseParams.TEMPLATE_TYPE = ''
  baseParams.TWO_HITS = "" ;
  baseParams.UNIQ_DEFAULTS_NAME="A_SearchDefaults_1N2ADa_oee_1Z5H3Q7o1_GTR6V_1OgPIQ";
  baseParams.USER_DATABASE="";
  baseParams.USER_DEFAULT_MATCH_SCORES="0";
  baseParams.USER_DEFAULT_PROG_TYPE="megaBlast";
  baseParams.USER_FORMAT_DEFAULTS="";
  baseParams.USER_MATCH_SCORES="";
  baseParams.USER_WORD_SIZE="";
  baseParams.WORD_SIZE = '28';
  baseParams.WWW_BLAST_TYPE = "";
  if (params){
    for(var key in params) {
      baseParams[key] = params[key];
    }

  }


  var url = 'http://blast.ncbi.nlm.nih.gov/Blast.cgi';
  var form = document.createElement("form");
  form.setAttribute("target", "_blank");
  form.setAttribute("method", "POST");
  form.setAttribute("action", url);
  form.setAttribute("enctype","multipart/form-data");
  form.setAttribute("class", "f-wrap-1 all");
  form.setAttribute("id",node_id);// "ncbi-blast-search-form");

  for(var key in baseParams) {
    var hiddenField = document.createElement("input");
    hiddenField.setAttribute("type", "hidden");
    hiddenField.setAttribute("name", key);
    hiddenField.setAttribute("id", key);
    hiddenField.setAttribute("value", baseParams[key]);

    form.appendChild(hiddenField);
  }
  var node =$("#" + node_id) ;
  if (node){
    node.replaceWith(form);

  } else {
  }
  form.submit();
}


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
      tbar:[
      {
        iconCls:'new_fasta',
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
            params.JOB_TITLE = 'HIMB-'+record.name;
            params.QUERY     = record.seq;
            Ext.bio.ncbiBlastSearch("ncbi-blast-search-form",params);
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

    Ext.getCmp('tbar-item-sequence-title').setText("Sequence <b>" + record.name + "</b>");
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
      sequence:sequence
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
Ext.reg('bio-sequence-view-panel', Ext.bio.BiosequenceViewPanel);

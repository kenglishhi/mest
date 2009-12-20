Ext.namespace('Ext.bio.clustalW');

Ext.bio.clustalW.formatStarsLine = function(str,maxSeqNameLength) {
  var paddingLength = 6;
  var rg = new RegExp('^[\\s]{'+ (maxSeqNameLength + paddingLength ) +  '}') ;
  str = str.replace(rg,'');
  str = str.replace(/\s/g,'&nbsp;');
  return str;
}
Ext.bio.clustalW.formatSequence = function(seq) {
  seq = seq.replace(/(A+)/g, "<span class='dna-a'>$1</span>");
  seq = seq.replace(/(T+)/g, "<span class='dna-t'>$1</span>");
  seq = seq.replace(/(C+)/g, "<span class='dna-c'>$1</span>");
  return seq;
}


Ext.bio.AlignmentViewPanel =  Ext.extend(Ext.Panel, {
  title: 'ClustalW Alignment',
  initComponent: function() {
    Ext.apply(this,{
      autoScroll: true,
      items: [{
        id:'inner-alignment-panel',
        html: "No Alignment to preview "
      }]
    /*      ,
      tbar: [{
        text:'Update content',
        viewPanelId: this.id,
        handler: function() {
          Ext.getCmp(this.viewPanelId).updateContent({
            url: 'http://mest/system/fastas/40/original/EST_Clade_A_vs_C_Clean_007.aln'
          });
        }
      },{
        text: 'Clear Content',
        viewPanelId: this.id,
        handler: function() {
          Ext.getCmp(this.viewPanelId).clearContent();
        }
      }
      ]
      */
    })
    Ext.bio.AlignmentViewPanel.superclass.initComponent.call(this);
  },
  listeners: {
    afterrender: function() {
      if (this.biodatabase_id) {
        this.updateContent({ 
          biodatabase_id: this.biodatabase_id
        });
      }
    }
  },
  clearContent: function() {
    if (this.rendered) {
      Ext.getCmp('inner-alignment-panel').getEl().update('&nbsp;');
    }
  },
  updateContent: function(params) {
    if (params && params.biodatabase_id) {
      this.biodatabase_id  = params.biodatabase_id ;
      var url = 'http://mest/workbench/alignments/1.json';
      if (this.rendered) {
        Ext.Ajax.request({
          url:  url,
          params: { 
            biodatabase_id: this.biodatabase_id
          },
          method:'GET',
          success: function(response) {
            var alnObj = Ext.util.JSON.decode(response.responseText);
            var clustalwOutput = '<table class="clustalw-table">';
            for (var seqId in alnObj) {
              if (seqId != "MATCH_LINE") {
                clustalwOutput += '<tr><td class="seq-name-cell">' + seqId + '</td>';
                clustalwOutput += '<td>' + Ext.bio.clustalW.formatSequence(alnObj[seqId].seq) + '</td></tr>';
              }
            }
            if (alnObj['MATCH_LINE']){
              clustalwOutput  += '<tr><td class="seq-name-cell">&nbsp;</td><td>' +  alnObj['MATCH_LINE'].seq+ '</td></tr>';
            }
            clustalwOutput += '</table>';
            Ext.getCmp('inner-alignment-panel').getEl().update(clustalwOutput);
          }
        });

      }
    }

  }
});

Ext.reg('alignment-view-panel', Ext.bio.AlignmentViewPanel);

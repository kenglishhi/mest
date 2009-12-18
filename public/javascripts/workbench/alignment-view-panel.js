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
      if (this.alnFileUrl) {
        this.updateContent({ 
          url:this.alnFileUrl
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
    if (params && params.url) {
      this.alnFileUrl  = params.url ;
      if (this.rendered) {
        Ext.Ajax.request({
          url:  this.alnFileUrl,
          success: function(response) {
            var i;
            var clustalwOutputLines = response.responseText.split("\n");
            // remove the first 3 lines
            for (var i=0;i<3;i++) {
              clustalwOutputLines.remove( clustalwOutputLines[0]);
            }

            var clustalwOutput = '<table class="clustalw-table">';
            var maxSeqNameLength = 0;
            for (i =0; i < clustalwOutputLines.length; i++) {
              var line = clustalwOutputLines[i];
              if (line.match(/^CLUSTAL/)) {
              } else if (line.length ==0)  {
                clustalwOutput  += '<tr><td>&nbsp;</td><td>&nbsp;</td></tr>';
              } else if (line.match(/\*/)) {
                clustalwOutput  += '<tr><td>&nbsp;</td><td>' + Ext.bio.clustalW.formatStarsLine(line,maxSeqNameLength) + '</td></tr>';
              }  else {
                var seqs = line.split(/\s+/);
                var seqName = seqs[0];
                var seq = seqs[1];
                if (seq.length==0 &&  seqName.length==0) {
                  clustalwOutput  += '<tr><td>&nbsp;</td><td>&nbsp;</td></tr>';
                  continue;
                }

                if (seqName.length > maxSeqNameLength) {
                  maxSeqNameLength = seqName.length
                }
                clustalwOutput  += '<tr><td class="seq-name-cell">' +  seqName + '</td><td>' + Ext.bio.clustalW.formatSequence(seq)  + '</td></tr>';
              }
            }
            clustalwOutput += '</table>';
            Ext.getCmp('inner-alignment-panel').getEl().update(clustalwOutput);
          },
          headers: {
          },
          params: {
        }
        });

      }
    }

  }
});

Ext.reg('alignment-view-panel', Ext.bio.AlignmentViewPanel);
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


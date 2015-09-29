$(document).on("page:change", function() {

  $("form").on("keypress", function (e) {
    if (e.keyCode == 13) {
        return false;
    }
  });

  $('#draft_radiant_1').fuzzyDropdown({
    mainContainer: '#radiant_1_search',
    arrowUpClass: 'fuzzArrowUp',
    selectedClass: 'selected',
    enableBrowserDefaultScroll: true
  });
  $('#draft_radiant_2').fuzzyDropdown({
    mainContainer: '#radiant_2_search',
    arrowUpClass: 'fuzzArrowUp',
    selectedClass: 'selected',
    enableBrowserDefaultScroll: true
  });
  $('#draft_radiant_3').fuzzyDropdown({
    mainContainer: '#radiant_3_search',
    arrowUpClass: 'fuzzArrowUp',
    selectedClass: 'selected',
    enableBrowserDefaultScroll: true
  });
  $('#draft_radiant_4').fuzzyDropdown({
    mainContainer: '#radiant_4_search',
    arrowUpClass: 'fuzzArrowUp',
    selectedClass: 'selected',
    enableBrowserDefaultScroll: true
  });
  $('#draft_radiant_5').fuzzyDropdown({
    mainContainer: '#radiant_5_search',
    arrowUpClass: 'fuzzArrowUp',
    selectedClass: 'selected',
    enableBrowserDefaultScroll: true
  });
  $('#draft_dire_1').fuzzyDropdown({
    mainContainer: '#dire_1_search',
    arrowUpClass: 'fuzzArrowUp',
    selectedClass: 'selected',
    enableBrowserDefaultScroll: true
  });
  $('#draft_dire_2').fuzzyDropdown({
    mainContainer: '#dire_2_search',
    arrowUpClass: 'fuzzArrowUp',
    selectedClass: 'selected',
    enableBrowserDefaultScroll: true
  });
  $('#draft_dire_3').fuzzyDropdown({
    mainContainer: '#dire_3_search',
    arrowUpClass: 'fuzzArrowUp',
    selectedClass: 'selected',
    enableBrowserDefaultScroll: true
  });
  $('#draft_dire_4').fuzzyDropdown({
    mainContainer: '#dire_4_search',
    arrowUpClass: 'fuzzArrowUp',
    selectedClass: 'selected',
    enableBrowserDefaultScroll: true
  });
  $('#draft_dire_5').fuzzyDropdown({
    mainContainer: '#dire_5_search',
    arrowUpClass: 'fuzzArrowUp',
    selectedClass: 'selected',
    enableBrowserDefaultScroll: true
  });

  // $('select').on('change', function() {
  //   if (this.id !== "draft_winrate") {
  //     var val = this.value;
  //     var id = this.id;
  //     var text = this.options[this.selectedIndex].text

  //     $('select').each(function() {
  //       if (this.id !== id && this.id !== "draft_winrate") {
  //         $('#'+this.id+' option[value="'+val+'"]').remove();
  //         if ($('#'+id+'').data('pre_val') !== undefined && $('#'+id+'').data('pre_val') !== '') {

  //           $(this).append($("<option></option>").attr("value", $('#'+id+'').data('pre_val')).text($('#'+id+'').data('pre_text')));
  //         };
  //       };
  //     });

  //     $(this).data('pre_val', val);
  //     $(this).data('pre_text', text);
  //   };
  // });

});
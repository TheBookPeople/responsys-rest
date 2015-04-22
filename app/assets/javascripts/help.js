!function ($) {
  'use strict';

  $(function () {
  
    // Config ZeroClipboard
    ZeroClipboard.config({
      moviePath: '//cdnjs.cloudflare.com/ajax/libs/zeroclipboard/1.3.5/ZeroClipboard.swf',
      hoverClass: 'btn-clipboard-hover'
    })

    // Insert copy to clipboard button before .highlight
    $('.language-bash').each(function () {
      var highlight = $(this)
      var parent = highlight.parent();
      var btnHtml = '<div class="zero-clipboard"><span class="btn btn-default btn-clipboard"><span class="octicon octicon-clippy"> Copy Command</span></span></div>'
      parent.before(btnHtml)
    })
    var zeroClipboard = new ZeroClipboard($('.btn-clipboard'))
    var htmlBridge = $('#global-zeroclipboard-html-bridge')

    // Handlers for ZeroClipboard
    zeroClipboard.on('load', function () {    
      htmlBridge
        .data('placement', 'top')
        .attr('title', 'Copy command to clipboard')
        .tooltip()
    })

    // Copy to clipboard
    zeroClipboard.on('dataRequested', function (client) {
      var highlight = $(this).parent().next().children('.language-bash').first();    
      //console.log($(this)); 
      //console.log(highlight.text());
      client.setText(highlight.text());
    })

    // Notify copy success and reset tooltip title
    zeroClipboard.on('complete', function () {
      htmlBridge
        .attr('title', 'Copied!')
        .tooltip('fixTitle')
        .tooltip('show')
        .attr('title', 'Copy command to clipboard')
        .tooltip('fixTitle')
    })

    // Notify copy failure
    zeroClipboard.on('noflash wrongflash', function () {
      htmlBridge
        .attr('title', 'Flash required')
        .tooltip('fixTitle')
        .tooltip('show')
    })

  })

}(jQuery)
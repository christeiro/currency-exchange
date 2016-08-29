$(function(){
    new Morris.Line({
        // ID of the element in which to draw the chart.
        element: 'myfirstchart',
        data: $('#myfirstchart').data('rates'),
        // The name of the data record attribute that contains x-values.
        xkey: 'period',
        // A list of names of data record attributes that contain y-values.
        ykeys: ['predicted_rate'],
        // Labels for the ykeys -- will be displayed when you hover over the
        // chart.
        labels: ['Rate']
    });
})
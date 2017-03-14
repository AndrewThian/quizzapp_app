/* globals $ Materialize google */

$(document).on('turbolinks:load', function () {
  let statsTable = $('#stats_table')
  let statsChart = $('#donutchart')
  let id = $('#stats_table').attr('data-user-id')
  let currentQuestions = $('#overall_question_progress').attr('data-com-qn')

  let listButton = $('#list_button')
  let chartButton = $('#chart_button')

  var categoryData = []

  function questionComplete () {
    let completedPercentage = (currentQuestions / 1800) * 100
    $('#overall_question_progress').css('width', completedPercentage + '%')
    $('#percentage-done').html(Math.ceil(completedPercentage) + '%')
  }

  questionComplete()

  $.getJSON('/users/' + id, function (data) {
    categoryData = data.map(function (ele, ind) {
      return [ele.category.name, ele.category_id]
    })
    categoryData.unshift(['Category', 'Exp gained'])
    // console.log(categoryData)
    google.charts.load('current', {packages: ['corechart']})
    google.charts.setOnLoadCallback(drawChart)
    function drawChart () {
      var data = google.visualization.arrayToDataTable(categoryData)

      var options = {
        title: 'My Categories',
        pieHole: 0.4
      }

      var chart = new google.visualization.PieChart(document.getElementById('donutchart'))
      chart.draw(data, options)
    }
  })

  statsTable.hide()

  listButton.on('click', function () {
    console.log('list clicked')
    statsChart.hide()
    statsTable.show()
  })

  chartButton.on('click', function () {
    console.log('chart clicked')
    statsTable.hide()
    statsChart.show()
  })
})

/* globals $ Materialize */

$(document).on('turbolinks:load', function () {
  var timerBar = $('#timer_bar')
  var highscoreDiv = $('#highscore')
  var gameStartPage = $('#quiz_ready_page')
  var gameEndPage = $('#quiz_game_end')
  var gamePlayingPage = $('#quiz_playing_page')
  var gameNextPage = $('#quiz_next_page')

  // hide end game page when windows load
  gameEndPage.hide()
  timerBar.hide()
  gamePlayingPage.hide()
  gameNextPage.hide()

  let startButton = $('#ready_button')
  let restartButton = $('#restart_button')
  let nextButton = $('#next_button')
  let cheatButton = $('#cheat')
  let submitButton = $('#submit_highscore')

  cheatButton.hide()

  let id = $('#quiz_main_div').attr('data-category-id')
  var highscore = 0
  var timer = 100
  var interval = 0
  var timerStarted = false
  var currentQuestion = 0

  var questions = []
  var correctAnswers = []
  var incorrectAnswers = []
  var answersShuffled = []
  var questionIDs = []

  function shuffle (a) {
    var j, x, i
    for (i = a.length; i; i--) {
      j = Math.floor(Math.random() * i)
      x = a[i - 1]
      a[i - 1] = a[j]
      a[j] = x
    }
  }

  function loadQuestions () {
    $.getJSON('/categories/' + id + '/questions', function (data) {
      // console.log(data)
      data.questions.map(function (ele, ind) {
        questions.push(ele.question)
        questionIDs.push(ele.id)
        // console.log('question pushed', ele.question)
        incorrectAnswers.push(ele.incorrect_answers)
        // console.log('inc answers pushed', ele.incorrect_answers)
        correctAnswers.push(ele.correct_answer)
        // console.log('cor answer pushed', ele.correct_answer)
        let currentIncAnswerArr = ele.incorrect_answers
        let correctAnswer = ele.correct_answer
        let correctAnswerArr = []
        correctAnswerArr.push(correctAnswer)
        let concatAnswers = currentIncAnswerArr.concat(correctAnswerArr)
        // console.log('compiled answers', concatAnswers)
        // console.log(concatAnswers)
        shuffle(concatAnswers)
        // console.log('answers shuffled')
        answersShuffled.push(concatAnswers)
        // console.log('answer set pushed', currentIncAnswerArr)
      })
      // console.log(questions[0])
      // console.log(correctAnswers[0])
      // console.log(incorrectAnswers[0])
      // console.log(answersShuffled[0])
    })
  }

  function updateHighScore () {
    highscoreDiv.html('Highscore: ' + highscore)
  }

  updateHighScore()

  function gameEnd () {
    gameStartPage.hide()
    gamePlayingPage.hide()
    gameEndPage.show()
    timerBar.hide()
  }

  function checkTimer (time) {
    // console.log(timer)
    if (Number(time) === 0.00) {
      timerReset()
      gameEnd()
    }
  }

  function timerStart () {
    if (!timerStarted) {
      timerStarted = true
      // console.log('timer started')
      timerBar.show()
      interval = setInterval(function () {
        timer = Number(timer) - 0.1
        timer = timer.toFixed(2)
        timerBar.css('width', timer + '%')
        checkTimer(timer)
      }, 10)
    }
  }

  function timerPause () {
    // console.log('timer paused')
    // console.log(timer)
    timerStarted = false
    timerBar.hide()
    clearInterval(interval)
  }

  function timerReset () {
    if (timerStarted === true) {
      // console.log('timer reset')
      // console.log(timer)
      clearInterval(interval)
      timerStarted = false
      timer = 100
      timerBar.css('width', timer + '%')
      // console.log(interval)
      // console.log(timer)
    }
  }

  function nextPageShow () {
    // console.log('next page called')
    gamePlayingPage.hide()
    $('#current_question').html('Nice! Next question: ' + (currentQuestion + 1))
    highscore += 1
    // console.log('highscore: ' + highscore)
    updateHighScore()
    gameNextPage.show()
    // timerStart()
    // updateQuestion()
  }

  // load questions before startbutton
  loadQuestions()

  function updateQuestion () {
    $('#add_question').html(questions[currentQuestion])
    for (var i = 0; i < answersShuffled[currentQuestion].length; i++) {
      if (answersShuffled[currentQuestion][i] === correctAnswers[currentQuestion]) {
        $('.answer_button' + [i]).html(answersShuffled[currentQuestion][i])
        $('.answer_button' + [i]).off()
        $('.answer_button' + [i]).on('click', function () {
          $.ajax({
            type: 'PUT',
            url: '/categories/' + id + '/questions/' + questionIDs[currentQuestion]
          }).success(function (json) {
            // console.log('success')
            Materialize.toast('Correct!')
            currentQuestion++
            timerPause()
            updateHighScore()
            nextPageShow()
          })
        })
      } else {
        $('.answer_button' + [i]).html(answersShuffled[currentQuestion][i])
        $('.answer_button' + [i]).off()
        $('.answer_button' + [i]).on('click', function () {
          timerReset()
          updateHighScore()
          gameEnd()
          // console.log('highscore: ', highscore)
        })
      }
    }
    cheatButton.show()
    cheatButton.off()
    cheatButton.on('click', function () {
      $.ajax({
        type: 'PUT',
        url: '/categories/' + id + '/questions/' + questionIDs[currentQuestion]
      }).success(function (json) {
        // console.log('success')
        Materialize.toast('Correct!')
        currentQuestion++
        timerPause()
        updateHighScore()
        nextPageShow()
      })
    })
  }

  startButton.on('click', function () {
    Materialize.toast('Game start!', 2000)
    // console.log('game start!')

    setTimeout(function () {
      gameStartPage.hide()
      // console.log('ready page hidden..')
      timer = 100
      timerStart()
      updateHighScore()
      updateQuestion()
      gamePlayingPage.show()
      // console.log(questions[currentQuestion])
      // console.log(correctAnswers[currentQuestion])
      // console.log('incorrect answers', incorrectAnswers[currentQuestion])
      // console.log('answers array', answersShuffled[currentQuestion])
      // console.log('Question ID', questionIDs[currentQuestion])
    }, 350)
  })

  nextButton.on('click', function () {
    gameNextPage.hide()
    gamePlayingPage.show()
    timer = 100
    timerBar.css('width', timer + '%')
    updateQuestion()
    updateHighScore()
    timerStart()
  })

  restartButton.on('click', function () {
    Materialize.toast('Game restarted', 2000)
    // console.log('game restart!')

    setTimeout(function () {
      gameEndPage.hide()
      highscore = 0
      updateHighScore()
      gameStartPage.show()
    }, 350)
  })

  submitButton.on('click', function () {
    // console.log('submit clicked')
    $.ajax({
      type: 'PUT',
      url: '/categories/' + id + '/highscore/' + highscore
    }).success(function (json) {
      console.log('highscore submitted')
      Materialize.toast('Highscore Submitted!')
    })
  })
})

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: Arial, sans-serif;
      background: #f9f9f9;
    }
    .calendar-container {
      max-width: 1000px;
      margin: 5px auto;
      padding: 10px;
    }
    #calendar {
      background: #fff;
      padding: 10px;
      border-radius: 10px;
      box-shadow: 0 0 10px #ccc;
    }
    @media (max-width: 600px) {
      #calendar {
        padding: 5px;
      }
    }
  </style>
</head>
<body>

  <div class="calendar-container">
    <div id="calendar"></div>
  </div>

  <?php
    $account_id = isset($_GET['account_id']) ? $_GET['account_id'] : 1;
  ?>

  <script>
    document.addEventListener('DOMContentLoaded', function () {
      let accountId = <?php echo json_encode($account_id); ?>;
      const calendarEl = document.getElementById('calendar');

      const calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        headerToolbar: {
          left: 'prev,next today',
          center: 'title',
          right: ''
        },
        height: 'auto',
        contentHeight: 'auto',
        aspectRatio: 1.35,
        windowResize: true,
        events: {
          url: './calendarApi.php',
          method: 'GET',
          extraParams: {
            account_id: accountId
          },
          failure: function () {
            alert('Failed to fetch events!');
          }
        },
        eventClick: function (info) {
          const event = info.event;
          alert(
            `📌 ${event.title}\n` +
            `Date: ${event.start.toLocaleDateString()}\n` +
            `Status: ${event.extendedProps.status}\n` +
            `Description: ${event.extendedProps.description}`
          );
        }
      });

      calendar.render();
    });
  </script>

</body>
</html>

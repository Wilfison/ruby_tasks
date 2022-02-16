# Ruby Simple task manager

## Simple task manager built in ruby and managed by cron jobs

### How to use

#### Install the dependencies.

`bundle install`

#### Create your first task. 

Create a copy of the `tasks.sample.json` file to `tasks.json`. This file will be read by the script whenever called by cronjob.

```JSON
{
  "before_run": [
    "echo 'running before tasks'"
  ],
  "tasks": [
    {
      "name": "Say Hello",
      "slug": "sey_hello", // Information used to create the log and other data
      "date": "2021-12-20", // Date on which the task will be executed
      "hour": "09:54", // Task execution time
      // command array that will be executed in sequence
      "commands": [
        "echo 'hello world!'",
        "echo 'hi, i am ruby script!'"
      ]
    }
  ]
}

```

When executing a task, a log file will be created in `"./logs/my_task_slug.log"`.


### Creating the cron job

Open your crontab file


`sudo nano /etc/crontab`

Add a new entry

```shell
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
```

```shell
# Using pure ruby
*/1 *   * * *   root    cd my_tasks_folder && /bin/ruby ./app.rb > /tmp/ruby-tasks.log 2>&1
```

```shell
# Using RVM
*/1 *   * * *   root    cd my_tasks_folder && /usr/local/rvm/wrappers/ruby-2.5.1@ruby-tasks/ruby ./app.rb > /tmp/ruby-tasks.log 2>&1
#
```

`> /tmp/ruby-tasks.log 2>&1` save command output for debug.

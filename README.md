## How to run with docker compose
```
docker compose up
```
maybe an error occur after running this command because the web persistent volume does not contain a suitable database for the web api service, to fix this error run
```
docker compose down
docker compose run web rake db:create
docker compose run web rake db:migrate
```
then run
```docker compose up```
again

## Highlevel architecture


## Data representaion and ERD 

Application: id, Token, name, chats_count, last_request_time
Chat: id, application_id, number, title, messages_count, last_request_time
Message: id, chat_id, number, body, last_request_time

## Routes 

## Challenges

- Writing on database
  - Writing on the database (create or update requests) takes a lot of time. The solution was using queueing system. Every create and update requests will be enqueued and there are workers that dequeue those requests. Workers work in parallel (up to 5 workers) and the database accepts up to 5 concurrent threads.
 
- Syncing with elastic search
  - On every create of update for a messsage, after comminting the change, the record is updated in the elastic search index.
- Returning the chat number / message number in the creation response.
  - Actually this is the most challenging problem that faced me. the problem is that we write on database asyncrounsly while other servers concurrently are doing the same thing.
    - Use cache. By the help of a redis cache, every application token has the number of its chats count, and every chat has the number of its messages count.
    - After recieveing a create request (for example create chat request), the api check if the application of this chat has its chats count in the cache (if not, go and read if from the database, that actually means that this is the first create chat request related to this application) then increment this number to be the number of the newly created chat, and update the cache.
    - The previous point needs to be done in a critical section that cannot be executed by more than one process (use mutex), otherwise problems may occur.
    - Implementing the critical section while accessing the cache is a bottleneck for creating chats concurrently.
    - Finally the newly chosen number for the chat is passed to the worker.
    - Future work: we can only lock the application key instead of locking the whole cache.
    - All the previous points apply also on the message creation process.
- Updating and race conditions
  - Image 2 update requests for the same entity reach the system, update A reaches before update B by a little bit.
  - Due to scheduling, the worker of update B may execute before the worker of update A.
  - To solve this problem, we attache the time stamp of entering the api server for each request and pass it to the worker, the worker will not do an update if the last update's request timestamp is smaller than the currently attached one.
  - So we actually need to store the request arrival time for each create/update, but the check is only needed while updating an entity.
- Creating background process and queue with sidekiq
  - The queuing as a concept was not a "challenge", but implementing this for the first time was an interesting thing.
- Database indexes
  - There are some queries that use conditions may be executed for many times.
    - For applications table there is an index on the token column
    - For chats table there is a composite index on the (application_id, chat_number)
    - For the messages table there is a composite index in (chat_id, message_number)
  - 

module Sidekiq
  class CancelWorker < Exception;end
  module Middlewares
    class Cancellable
      def call(worker, msg, queue)
        unless have_batch?
          yield
          return
        end

        worker_thread = Thread.current
        check_thread = Thread.start do
          loop do
            begin
              if worker_thread[:bid].valid?
                sleep(0.5)
              else
                worker_thread.raise(CancelWorker, 'Canceling build') # sometimes you just shoot horse in the head
                break
              end
            rescue => e
              worker_thread.raise e
              break
            end
          end
        end

        yield
      ensure
        if check_thread
          check_thread.kill
          check_thread.join
        end
      end

      private

      def have_batch?
        Thread.current[:bid]
      end

    end
  end
end

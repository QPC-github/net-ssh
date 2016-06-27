require 'common'
require 'net/ssh/transport/cipher_factory'

module Transport
  class TestThreaded < Test::Unit::TestCase

    def test_threaded_ctr_should_not_break_singletons
      Array.new(2) { define_singleton_methods_in_thread }.each(&:join)
    end

    private

    def define_singleton_methods_in_thread
      Thread.new do
        100_000.times do
          opts = {
            encrypt: true,
            iv: 'ABC',
            key: "abc",
            digester: OpenSSL::Digest::MD5,
            shared: "1234567890123456780",
            hash: '!@#$%#$^%$&^&%#$@$',
          }

          obj = Net::SSH::Transport::CipherFactory.get('aes256-ctr', opts)
          assert obj.respond_to?(:update)
        end
      end
    end
  end
end

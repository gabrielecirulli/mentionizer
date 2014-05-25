class TwitterUrl < Struct.new(:url)
  VALID_SCHEMES = %w(http https)
  VALID_DOMAINS = %w(twitter.com www.twitter.com)
  INVALID_USERNAMES = %w(share about privacy jobs)

  def username
    return nil unless VALID_SCHEMES.include?(uri.scheme)
    return nil unless VALID_DOMAINS.include?(uri.host)

    chunks = uri.path.split(/\//).select(&:present?)

    return nil if chunks.size != 1
    return nil if INVALID_USERNAMES.include?(chunks.first)

    chunks.first
  rescue URI::InvalidURIError, ArgumentError => e
    nil
  end

  def uri
    @uri ||= if url =~ %r{^//}
               URI('http:' + url)
             else
               URI(url)
             end
  end
end


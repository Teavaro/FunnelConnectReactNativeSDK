package com.funnelconnectreactnativesdk

import com.teavaro.funnelConnect.data.remote.rest.RestClientException

fun Exception.returnOrExtractExceptionIfTeavaroRestClientException(): Exception =
  if (this is RestClientException) {
    when (this) {
      is RestClientException.HttpError -> Exception("${this.statusCode} ${this.errorMessage}")
      else -> Exception(this.errorMessage)
    }
  } else this

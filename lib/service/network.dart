enum Status {
  SUCCESS, PENDING, ERROR, NETWORK_ERROR
}

class NetworkStatus<T> {
  Status status;
}

class SuccessState<T> extends NetworkStatus<T> {
  T data;
  SuccessState({this.data}) {
    status = Status.SUCCESS;
  }
}

class PendingState<T> extends NetworkStatus<T> {
  PendingState() {
    status = Status.PENDING;
  }
}

class ErrorState<T> extends NetworkStatus<T> {
  String error;
  ErrorState({this.error}) {
    status = Status.ERROR;
  }
}

class NetworkErrorState<T> extends NetworkStatus<T> {
  String error;
  NetworkErrorState({this.error}) {
    status = Status.ERROR;
  }
}

// bool isSuccess(NetworkStatus networkStatus) {
//   return networkStatus.status == Status.SUCCESS;
// }
//
// bool isPending(NetworkStatus networkStatus) {
//   return networkStatus is PendingState;
// }
//
// bool isError(NetworkStatus networkStatus) {
//   return networkStatus is ErrorState;
// }
//
// bool isNetworkError(NetworkStatus networkStatus) {
//   return networkStatus is NetworkErrorState;
// }


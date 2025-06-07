import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsersEvent extends HomeEvent {}

class UpdateProfileEvent extends HomeEvent {}

class SearchUserEvent extends HomeEvent {
  final String searchQuery;

  const SearchUserEvent(this.searchQuery);

  @override
  List<Object?> get props => [searchQuery];
}

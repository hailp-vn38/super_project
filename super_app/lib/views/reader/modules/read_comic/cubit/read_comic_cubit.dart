import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/views/reader/cubit/reader_cubit.dart';

part 'read_comic_state.dart';

class ReadComicCubit extends Cubit<ReadComicState> {
  ReadComicCubit({required this.readerCubit}) : super(ReadComicInitial());

  final ReaderCubit readerCubit;

  Book get getBook => readerCubit.args.book;

  List<Chapter> get getChapters => readerCubit.args.chapters;

  void onInit() {}
}

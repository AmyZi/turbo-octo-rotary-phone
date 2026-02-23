abstract class RepositoryInterface<T> {

  Future<dynamic> add(T value);

  Future<dynamic> update(T value, {int? id});

  Future<dynamic> delete(String id);

  Future<dynamic> getList({int? offset = 1});

  Future<dynamic> get(String id);
}
import 'package:flutter/material.dart';
import 'package:todo_cubit/frameworks/common_service.dart';
import 'package:todo_cubit/models/todo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/presentation/todos/cubit/todos_cubit.dart';
import 'package:todo_cubit/presentation/todos/widgets/delete_todo_snack_bar.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem(this.todo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _value = todo.isComplete;

    return Dismissible(
      key: ValueKey(todo.id),
      onDismissed: (direction) {
        context.read<TodosCubit>().deleteTodo(todo);

        ScaffoldMessenger.of(context).showSnackBar(
          DeleteTodoSnackBar(
            todo: todo,
            onUndo: () => context.read<TodosCubit>().addTodo(todo),
          ),
        );
      },
      child: InkWell(
        onTap: () => CommonService.showEditTodoDialog(context, todo: todo),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Checkbox(
                value: _value,
                onChanged: (val) {
                  context
                      .read<TodosCubit>()
                      .updateTodo(todo.copyWith(isComplete: val!));
                },
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(todo.title, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(todo.note),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

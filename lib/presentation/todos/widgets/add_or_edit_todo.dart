import 'package:flutter/material.dart';
import 'package:todo_cubit/models/todo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/presentation/todos/cubit/todos_cubit.dart';
import 'package:uuid/uuid.dart';

class AddOrEditTodo extends StatefulWidget {
  final bool isEdit;
  final Todo? todo;

  const AddOrEditTodo({Key? key, this.isEdit = false, this.todo})
      : super(key: key);

  @override
  _AddOrEditTodoState createState() => _AddOrEditTodoState();
}

class _AddOrEditTodoState extends State<AddOrEditTodo> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _notesController.text = widget.todo!.note;
    }
  }

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
    _notesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.isEdit ? 'Edit Todo' : 'Add Todo',
            style: const TextStyle(fontSize: 20)),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: 'What need to be done?',
            labelText: 'Title',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Additional Notes...',
            labelText: 'Notes',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(fontSize: 20)),
            ),
            TextButton(
              onPressed: () async {
                final Todo todo = Todo(
                  id: widget.todo?.id ?? const Uuid().v4(),
                  title: _titleController.text,
                  note: _notesController.text,
                  isComplete: widget.todo?.isComplete ?? false,
                );

                if (widget.isEdit) {
                  final bool isSuccess =
                      await context.read<TodosCubit>().updateTodo(todo);
                  if (isSuccess) Navigator.pop(context);
                } else {
                  final bool isSuccess =
                      await context.read<TodosCubit>().addTodo(todo);
                  if (isSuccess) Navigator.pop(context);
                }
              },
              child: const Text('Ok', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ],
    );
  }
}

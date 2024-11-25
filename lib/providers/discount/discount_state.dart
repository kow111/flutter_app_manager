part of 'discount_cubit.dart';

@immutable
sealed class DiscountState {}

final class DiscountInitial extends DiscountState {}

final class DiscountLoading extends DiscountState {}

final class DiscountLoaded extends DiscountState {
  final List<DiscountModel> discounts;
  final int totalPage;

  DiscountLoaded({
    required this.discounts,
    required this.totalPage,
  });
}

final class DiscountFailure extends DiscountState {
  final String error;

  DiscountFailure(this.error);
}

final class DiscountAddSuccess extends DiscountState {}

final class DiscountAddFailure extends DiscountState {
  final String error;

  DiscountAddFailure(this.error);
}

final class DiscountAddLoading extends DiscountState {}
 
//  In the  discount_state.dart  file, we define the state classes for the  DiscountCubit . The  DiscountState  class is a sealed class that contains the following state classes: 
 
//  DiscountInitial : The initial state of the  DiscountCubit . 
//  DiscountLoading : The state when the  DiscountCubit  is loading the discounts. 
//  DiscountLoaded : The state when the  DiscountCubit  has successfully loaded the discounts. 
//  DiscountFailure : The state when the  DiscountCubit  has failed to load the discounts. 
//  DiscountAddSuccess : The state when the  DiscountCubit  has successfully added a discount. 
//  DiscountAddFailure : The state when the  DiscountCubit  has failed to add a discount. 
//  DiscountAddLoading : The state when the  DiscountCubit  is loading the process of adding a discount. 
 
//  The  DiscountLoaded  state class contains the  discounts  and  totalPage  properties. The  discounts  property is a list of  DiscountModel  objects, while the  totalPage  property is the total number of pages of discounts. 
//  Step 4: Create the DiscountCubit 
//  In this step, we will create the  DiscountCubit  class. The  DiscountCubit  class is a  Cubit  class that manages the state of the discounts. 
//  Create a new file named  discount_cubit.dart  in the  lib/providers/discount  directory and add the following code:
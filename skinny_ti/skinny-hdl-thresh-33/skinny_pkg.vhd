package skinnypkg is

	type tweak_size is (tweak_size_1n, tweak_size_2n, tweak_size_3n);

	function get_tweak_fact (ts : tweak_size) return integer;
	function get_tweak_size (ts : tweak_size) return integer;
	function get_number_of_rounds (ts : tweak_size) return integer;

end skinnypkg;

package body skinnypkg is

	function get_tweak_fact (ts : tweak_size) return integer is
	begin
		if    ts = tweak_size_1n then
			return 1;
		elsif ts = tweak_size_2n then
			return 2;
		else
			return 3;
		end if;
	end get_tweak_fact;

	function get_tweak_size (ts : tweak_size) return integer is
	begin
		return 128 * get_tweak_fact(ts);
	end get_tweak_size;

	function get_number_of_rounds (ts : tweak_size) return integer is
	begin
		return (28 + (128 / 16) * get_tweak_fact(ts)) + 4 * (128 / 128);
	end get_number_of_rounds;

end skinnypkg;

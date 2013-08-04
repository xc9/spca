USAGE="Usage: -n/-m: thresholdes, -o: a or b, -f: matrix file, -w, word dictionary file, t: title dictionary file, c: 0, 1 or 2"

while getopts ":n:m:o:f:w:t:c:p:q:" OPTIONS; do
  case $OPTIONS in
    n ) threshold_n=$OPTARG;;
    m ) threshold_m=$OPTARG;;
    o ) option=$OPTARG;;
	f ) matrix_file=$OPTARG;;
	w ) word_file=$OPTARG;;
	t ) title_file=$OPTARG;;
	c ) center_option=$OPTARG;;
	p ) output_file=$OPTARG;;
	q ) title_output_file=$OPTARG;;
    \? ) echo "Invalid option: -$OPTARG" >&2 
		 echo $USAGE
         exit 1;;
  esac
done
if [ $threshold_n ]
    then
        echo "threshold_n set to ${threshold_n}"
	else
		thershold_n=15
		echo "threshold_n defaulted to ${threshold_n}"
fi

if [ $threshold_m ]
    then
        echo "threshold_m set to ${threshold_m}"
	else
		threshold_m=150
		echo "threshold_m defaulted to ${threshold_m}"
fi

if [ $option ]
    then
        echo "using pc-removal option ${option}"
	else
		option=b
		echo "option defaulted to ${option}"
fi

if [ -z $matrix_file ]
    then
        echo "Error, matrix file required"
		exit 1
fi

if [ -z $word_file ]
    then
        echo "Error, word file required"
		exit 1
fi
if [ $center_option ]
    then
        echo "Using centering option ${center_option}"
	else
		center_option=0
		echo "center option defaulted to ${center_option}"
fi

if [ -z $title_file ]
    then
        matlab -nodisplay -nodesktop -minimize -r "addpath(genpath(fullfile(pwd,'code')));
		 addpath(genpath(fullfile(pwd,'code'))); 
		 addpath(genpath(fullfile(pwd,'code')));
		 M=Util.load_matrix('input\\${matrix_file}',1);
		 options = Util.make_option(${threshold_m}, ${threshold_n}, 0.001, 50, 10, '${option}', ${center_option});
		 [ps, qs] = repeated_power_iteration(M, options); 
		 words=Util.load_dict('input\\${word_file}');
		 [indices, weights] = Util.get_indices_and_weights(qs); 
		 word_pc_list = words(indices); 
		 Util.conveniencePrintCSV('output\\${output_file}', word_pc_list, weights);" 
	 else
		 matlab -nodisplay -nodesktop -minimize -r "addpath(genpath(fullfile(pwd,'code')));
		 addpath(genpath(fullfile(pwd,'code'))); 
		 addpath(genpath(fullfile(pwd,'code')));
		 M=Util.load_matrix('input\\${matrix_file}',1);
		 options = Util.make_option(${threshold_m}, ${threshold_n}, 0.001, 50, 10, '${option}', ${center_option});
		 [ps, qs] = repeated_power_iteration(M, options); 
		 words=Util.load_dict('input\\${word_file}');
		 [indices, weights] = Util.get_indices_and_weights(qs); 
		 word_pc_list = words(indices); 
		 Util.conveniencePrintCSV('output\\${output_file}', word_pc_list, weights);
		 titles=Util.load_fnames('input\\${title_file}');
		 [indices, weights] = Util.get_indices_and_weights(ps,${threshold_n}); 
		 title_pc_list = titles(indices); 
		 Util.printTitles('output\\${title_output_file}', title_pc_list, weights);" 
fi

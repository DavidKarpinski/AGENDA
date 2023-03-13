use feature 'switch';
use Try::Tiny;

my %AGENDA = (
    'Alice' => {
        'age' => 25,
        'email' => 'alice@example.com',
        'address' => {
            'street' => '123 Main St',
            'city' => 'Anytown',
            'state' => 'CA',
            'zip' => '12345'
        }
    },
    'Bob' => {
        'age' => 28,
        'email' => 'bob@bobmail.com.uk',
        'address' => {
            'street' => '010 May St',
            'city' => 'Centertown',
            'state' => 'SY',
            'zip' => '67890',
        }
    }
);

sub iterate_recursive {
    my $hash_ref = shift;
    foreach (sort keys %$hash_ref) {
        my $value = $hash_ref->{$_};

        if (ref($value) eq 'HASH') {
            iterate_recursive($value);
        } else {
            print "$_: $value\n";
        }
    }
}

sub list {
    my $contact = shift;
    print uc("\n$contact\n");
    print "-"x30 . "\n";
    iterate_recursive($AGENDA{$contact});
    print "\n";
}

sub read_contacts {
    print "CONTACTS\n";
    print "-" x 30 . "\n";

    if (not scalar keys %AGENDA) {
        print "Your AGENDA is empty!\n";
    } else {
        my $i = 1;
        foreach my $key (sort keys %AGENDA) {
            print "$i -  $key\n";
            $i++;
        }
    }
}

sub remove {
    my $contact = shift;
    if (exists $AGENDA{$contact}) {
        delete $AGENDA{$contact};
    } elsif ($contact eq "*") {
        undef %AGENDA;
    } else {
        print "\nContact deleted: $contact!\n";
    }
}

sub append {
    my ($name, $age, $email, $address_ref) = @_;

    # Usage example:
    # %new_address = ('street' => '789 Sand St', 'city' => 'Sea Town', 'state' => 'SE', 'zip' => '18028');
    # append('Polly', 17, 'polly@express.com.lt', \%new_address);

    if (!exists $AGENDA{$name}) {
        $AGENDA{$name} = {
            'age' => $age,
            'email' => $email,
            'address' => $address_ref
        };
        print "\nContact added!\n";
    }
}

sub update_contact {
    my ($name, $age, $email, $address_ref) = @_;

    $AGENDA{$name} = {
        'age' => $age,
        'email' => $email,
        'address' => $address_ref
    };
    print "\nContact updated!\n";
}

sub menu {
	print "\nAGENDA\n";
	print "-"x30 . "\n";
	print "1 - List contacts\n";
	print "2 - Show a Contact\n";
    print "3 - Update a Contact\n";
    print "4 - Delete a Contact\n";
    print "5 - Append a Contact\n";

}

sub cli {
	for (;;) {
        init:
		print "\n";
		menu();
		$choice = <STDIN>;
		chomp $choice;

		given (int($choice)) {
			when (1) { read_contacts; }
			when (2) {
				read_contacts;
				print "Enter the contact: ";
				$contact = <STDIN>;
				chomp $contact;
				list $contact;
			}
            when (3) {
                read_contacts;

                name:
                print "\nEnter the name: ";
                my $name = <STDIN>;
                chomp $name;
                if (!exists $AGENDA{$name}) {
                    print "\nThe contact does not exists!\n";
                    goto name;
                }

                age:
                print "\nEnter the age: ";
                my $age = <STDIN>;
                $age = int($age);
                if ($age < 0 || $age > 110) {
                    print "\nInvalid age!\n";
                    goto age;
                }

                email:
                print "\nEnter the e-mail: ";
                my $email = <STDIN>;
                chomp $email;
                if (!$email =~ /^[^\s@]+@[^\s@]+\.[^\s@]+$/) {
                    print "\nInvalid email!\n";
                    goto email;
                }

                address:
                print "\nEnter the street: ";
                my $street = readline(STDIN);
                chomp $street;

                print "\nEnter the City: ";
                my $city = readline(STDIN);
                chomp $city;

                state:
                print "\nEnter the State: ";
                my $state = <STDIN>;
                chomp $state;
                if (length($state) != 2) {
                    print "\nInvalid State!\n";
                    goto state;
                }

                print "\nEnter the Zip: ";
                my $zip = <STDIN>;
                chomp $zip;

                my %address = {
                    'street' => $street,
                    'city' => $city,
                    'state' => $state,
                    'zip' => $zip
                };

                update_contact($name, $age, $email, \%address);
            }
            when (4) {
                read_contacts;
                if (not scalar keys %AGENDA) {
                    print "Type '*' to remove all contacts!\n";
                }
                print "Enter the contact: ";
                $contact = <STDIN>;
                chomp $contact;
                remove $contact;
            }
            when (5) {
                
            }
			default { print "\nInvalid Option\n"; }
		}
	}
}

my %addr = ('street' => '789 Sand St', 'city' => 'Sea Town', 'state' => 'SE', 'zip' => '18028');
append('Edwin', 29, 'edwin@myemail.com', \%addr);
# update_contact('Alice', 29, 'alice@myemail.com', \%addr);
cli();

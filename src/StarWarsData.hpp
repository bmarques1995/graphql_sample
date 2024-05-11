#pragma once

#include "graphqlservice/GraphQLService.h"

namespace graphql::star_wars {

	std::shared_ptr<service::Request> GetService() noexcept;

} // namespace graphql::star_wars